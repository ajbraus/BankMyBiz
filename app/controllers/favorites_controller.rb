class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @favorites = current_user.followed_users
  end
end
