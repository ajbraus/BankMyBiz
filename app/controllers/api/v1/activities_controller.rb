class Api::V1::ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  def index
    params[:id].present? ? @user = User.find(params[:id]) : @user = current_user
    @activities = PublicActivity::Activity.where('owner_id = ?', @user.id).paginate(:page => params[:page], :per_page => 5, order: "created_at desc")  #select { |a| a.trackable.present? }
    render 'api/activities/index'
  end
end