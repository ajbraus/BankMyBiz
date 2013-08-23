class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @user = current_user
    @subscription = @user.subscriptions.new(params[:subscription])
  end

  def create
    @subscription = current_user.subscriptions.new(params[:subscription])

    if @subscription.save_with_payment
      redirect_to root_path, :notice => "Your Account Was Successfully Upgraded"
    else
      render :new
    end
  end
end