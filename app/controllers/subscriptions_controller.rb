class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @user = current_user
    @subscription = @user.subscriptions.new(params[:subscription])
    if current_user.stripe_customer_id.present?
      @stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) 
      @cards = Stripe::Customer.retrieve(current_user.stripe_customer_id).cards.all
    end
  end

  def create
    plan = params[:subscription][:plan_id]
    if plan == "1" 
      params[:subscription][:expires_on] = Date.today + 1.month
    elsif plan == "2" || plan == "4"
      params[:subscription][:expires_on] = Date.today + 3.months
    elsif plan == "3" || plan == "5"
      params[:subscription][:expires_on] = Date.today + 6.months
    elsif plan == "6"
      params[:subscription][:expires_on] = Date.today + 1.year
    end

    @subscription = current_user.subscriptions.new(params[:subscription])

    if @subscription.valid? 
      if params[:existing_card_id].length > 5
        begin
          charge = Stripe::Charge.create(
            :amount => "#{@subscription.price}",
            :currency => "usd",
            :customer => current_user.stripe_customer_id,
            :card => params[:existing_card_id],
            :description => "Subscription for #{current_user.email}"
          )
        rescue
          redirect_to new_subscription_path(plan_id: plan), notice: "There was a problem with your subscription. Please try again."
          return
        end
      elsif params[:stripe_card_id].present?
        begin
          customer = Stripe::Customer.create(description:current_user.email, card:params[:stripe_card_id])
          charge = Stripe::Charge.create(
            :amount => "#{@subscription.price}",
            :currency => "usd",
            :customer => customer["id"],
            :description => "Match subscription for #{current_user.email}"
          )
          current_user.update_attributes(stripe_customer_id: customer.id)
        rescue
          redirect_to new_subscription_path(plan_id: plan), notice: "There was a problem with your subscription. Please try again."
          return
        end
      end

      @subscription.save
      redirect_to root_path, :notice => "Welcome to Bankmybiz360. You now have 360 degree access to users who interact with you."
      return
    else
      redirect_to new_subscription_path(plan_id: plan), notice: "There was a problem with your subscription. Please try again."
    end

    

    if @subscription.save_with_payment
      redirect_to root_path, :notice => "Your Account Was Successfully Upgraded"
    else
      render :new
    end
  end
end