class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @following = current_user.followed_users.order("created_at DESC")
    @followers = current_user.followers.order("created_at DESC")
  end
end
