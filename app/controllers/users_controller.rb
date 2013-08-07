class UsersController < ApplicationController
  impressionist
  def show
    @user = User.find(params[:id])
    if user_signed_in?
      is_bank = !current_user.bank?
      if @user == current_user
        @post = Post.new
      else
        @user.create_activity :show, owner: current_user
      end
    end
    @posts = @user.posts.paginate(:page => params[:page], :per_page => 7)
    @activities = PublicActivity::Activity.where(owner_id: @user.id).order("created_at desc").paginate(:page => params[:page], :per_page => 10) #.where(owner_id: current_user.friend_ids, owner_type: "User")
    @recommended_users = User.where(bank: is_bank).last
    @trending_tags = Tag.first(10)
  end

  def set_bank
    @user = User.find(params[:id])
    @user.update_attributes(bank: true)

    respond_to do |format|
      format.html { redirect_to edit_profile_path(@user) }
      format.js
      format.json { render json: @user }
    end  
  end

  def set_business
    @user = User.find(params[:id])
    @user.update_attributes(bank: false)

    respond_to do |format|
      format.html { redirect_to edit_profile_path(@user) }
      format.js
      format.json { render json: @user }
    end  
  end
end