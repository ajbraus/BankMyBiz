class RelationshipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.relationships.create!(followed_id: @user.id)

    @follower = current_user
    Message.create(
      subject: "New Follower:  #{@follower.first_name_with_last_initial} #{@follower.position} at #{@follower.org_name}",
      body: "#{@user.first_name}," + "\n\n" + 
            "#{@follower.first_name_with_last_initial} now follows you on Bankmybiz. They will be updated when you ask questions or post advice or Milestones on Bankmybiz. You can send them private and secure messages." + "\n\n" +
            "#{@follower.first_name_with_last_initial} is #{@follower.position} at #{@follower.org_name}." + "\n\n" +
            "A little bit about #{@follower.org_name}:" + "\n\n" +
            "#{@follower.bio}" + "\n\n" +
            "To learn more about #{@follower.name} visit their profile. Reply to this message to start a conversation.",
      sender_id: @follower.id,
      receiver_id: @user.id,
      is_read: false
      )

    Notifier.delay.new_follower(@user, current_user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end