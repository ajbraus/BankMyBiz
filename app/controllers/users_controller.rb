class UsersController < ApplicationController
  def show
    is_bank = !current_user.bank?
    @user = User.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @post = Post.new
      else
        @user.create_activity :create, owner: current_user
      end
    end
    @posts = @user.posts.paginate(:page => params[:page], :per_page => 20)
    @activities = PublicActivity::Activity.where(owner_id: current_user.id).order("created_at desc") #.where(owner_id: current_user.friend_ids, owner_type: "User")
    @recommended_users = User.where(bank: is_bank).first(3)
    @tags = Tag.first(20)
  end
end