class UsersController < ApplicationController
  def show
  	if user_signed_in?
  		@user = current_user
  	else
    	@user = User.find(params[:id])
    end
    @post = Post.new
    @posts = Post.paginate(:page => params[:page], :per_page => 10)
    @tags = Tag.first(5)
    @recommended_mocs = Post.first(5)
    @mocs = Post.first(5)
    @activities = PublicActivity::Activity.order("created_at desc") #.where(owner_id: current_user.friend_ids, owner_type: "User")
  end
end