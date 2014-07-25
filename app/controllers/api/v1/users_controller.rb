class Api::V1::UsersController < ApplicationController
  before_filter :authenticate_user_from_token!

  def show
    @user = User.find_by(auth_token: params[:id])
    if @user.blank?
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