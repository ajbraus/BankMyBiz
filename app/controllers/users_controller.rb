class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @post = Post.new
      end
    end
    @posts = @user.posts.paginate(:page => params[:page], :per_page => 20)
    @activities = PublicActivity::Activity.order("created_at desc") #.where(owner_id: current_user.friend_ids, owner_type: "User")
    @recommended_users = User.first(3)
  end
end