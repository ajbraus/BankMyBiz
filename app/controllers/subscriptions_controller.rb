class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @user = current_user
    @subscription = @user.subscriptions.new(params[:subscription])
  end

  def create
    @user = current_user
    @subscription = @user.subscriptions.new(params[:subscription])

    if @subscription.save_with_payment
      redirect_to @subscription, :notice => "Thank you for subscribing!"
    else
      render :new
    end
  end
end