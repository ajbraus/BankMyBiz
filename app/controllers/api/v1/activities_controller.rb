class Api::V1::ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  def index
    params[:user_id].present? ? @user = User.find(params[:user_id]) : @user = current_user
    @activities = PublicActivity::Activity.where(owner_id: @user.id).order("created_at desc").select { |a| a.trackable.present? }.paginate(:page => params[:page], :per_page => 5) 
    render 'api/posts/index'
  end
end