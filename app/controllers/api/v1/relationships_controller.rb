class Api::V1::RelationshipsController < ApplicationController
  before_filter :authenticate_user_from_token!
  
  def index
    @followed_users = current_user.followed_users
    @followers = current_user.followers

    render 'api/relationships/index' #refresh
  end

  def create
    @followed_user = User.find(params[:id])
    current_user.follow!(@followed_user)
    render 'api/relationships/show' #prepend new relationship to list
  end

  def destroy
    @relationship = current_user.relationship.find_by_followed_id(params[:id])
    @relationship.destroy
    render 'api/relationships/index' #refresh
  end
end