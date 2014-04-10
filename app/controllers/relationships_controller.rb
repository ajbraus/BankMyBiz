class RelationshipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.relationships.create!(followed_id: @user.id)

    Message.create(
      subject: "#{current_user.first_name_with_last_initial} wants to connect",
      body: "#{@user.first_name}," + "\n\n" + 
            "Hi, I'm interested in connecting with you on Bankmybiz." + "\n\n" +
            "Reply to this message to start a conversation",
      sender_id: current_user.id,
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