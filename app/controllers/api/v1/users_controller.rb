class Api::V1::UsersController < ApplicationController
  before_filter :authenticate_user_from_token!

  def show
    if params[:id].blank?
      @user = User.find_by_auth_token(params[:auth_token])      
    else
      @user = User.find(params[:id])
    end

    render 'api/users/show'
  end

  def update
    @post = User.find(params[:id])
    @post.update_attributes(params[:user])
    render 'api/users/show'
  end
end