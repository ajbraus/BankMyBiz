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
    plan = params[:subscription][:plan]
    if plan == "lender_three_months" 
      params[:subscription][:expires_on] = Date.today + 3.months
      params[:subscription][:price] = 74997
    elsif plan == "lender_six_months"
      params[:subscription][:expires_on] = Date.today + 6.months
      params[:subscription][:price] = 113994
    elsif plan == "lender_year"
      params[:subscription][:expires_on] = Date.today + 1.year
      params[:subscription][:price] = 155988
    end

    if current_user.stripe_customer_id.present? && params[:existing_card_id].length > 5 #existing card
      stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      stripe_subscription = customer.subscriptions.create(plan: plan, card: params[:existing_card_id])
    elsif current_user.stripe_customer_id.present? && params[:stripe_card_id].present? #new card
      stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      card = stripe_customer.cards.create(params[:stripe_card_id])
      stripe_subscription = customer.subscriptions.create(plan: plan, card: card)
    elsif current_user.stripe_customer_id.blank? && params[:stripe_card_id].present? #new customer
      customer = Stripe::Customer.create(
        :card => params[:stripe_card_id],
        :plan => plan,
        :email => current_user.email
      )
      current_user.update_attributes(stripe_customer_id: customer.id)
      stripe_subscription = customer.subscriptions.first
    end

    if stripe_subscription.present?
      @subscription = current_user.subscriptions.new(params[:subscription])
      @subscription.expires_on = Time.at(stripe_subscription.current_period_end).to_date
      @subscription.stripe_subscription_id = stripe_subscription.id
      @subscription.save
      return redirect_to root_path, :notice => "Successfully Certified!"
    else
     return redirect_to new_subscription_path(plan: plan), notice: "There was a problem with your subscription. Please try again."
    end
  end
end