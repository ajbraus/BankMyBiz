class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @user = current_user
    @subscription = @user.subscriptions.new(params[:subscription])
  end

  def create

    plan = params[:subscription][:plan_id]
    if plan == 1 
      params[:subscription][:expires_on] = Date.today + 1.month
    elsif plan == 2 || plan == 4
      params[:subscription][:expires_on] = Date.today + 3.months
    elsif plan == 3 || plan == 5
      params[:subscription][:expires_on] = Date.today + 6.months
    elsif plan == 6
      params[:subscription][:expires_on] = Date.today + 1.year
    end

    @subscription = current_user.subscriptions.new(params[:subscription])

    if @subscription.save_with_payment
      redirect_to root_path, :notice => "Your Account Was Successfully Upgraded"
    else
      render :new
    end
  end
end