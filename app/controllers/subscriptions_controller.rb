class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def new
    if current_user.stripe_customer_id.present?
      @stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) 
      @cards = Stripe::Customer.retrieve(current_user.stripe_customer_id).cards.all
    end
  end

  def create
    @date = current_user.subscriptions.any? ? current_user.subscriptions.last.expires_on : Date.today

    if params[:subscription][:plan_id] == "1"
      params[:subscription][:expires_on] = @date + 3.months
      params[:subscription][:price_in_cents] = 74997
    elsif params[:subscription][:plan_id] == "2"
      params[:subscription][:expires_on] = @date + 6.months
      params[:subscription][:price_in_cents] = 113994
    elsif params[:subscription][:plan_id] == "3"
      params[:subscription][:expires_on] = @date + 1.year
      params[:subscription][:price_in_cents] = 155988
    elsif params[:subscription][:plan_id] == "4"
      params[:subscription][:expires_on] = @date + 1.month
      params[:subscription][:price_in_cents] = 9999
    end

    if current_user.stripe_customer_id.present? && params[:existing_card_id].length > 5 #existing card
      stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      stripe_subscription = stripe_customer.subscriptions.create(plan: params[:subscription][:plan_id])
    elsif current_user.stripe_customer_id.present? && params[:stripe_card_id].present? #new card
      stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      stripe_subscription = stripe_customer.subscriptions.create(plan: params[:subscription][:plan_id], card: params[:stripe_card_id])
    elsif current_user.stripe_customer_id.blank? && params[:stripe_card_id].present? #new customer
      stripe_customer = Stripe::Customer.create(
        :card => params[:stripe_card_id],
        :plan => params[:subscription][:plan_id],
        :email => current_user.email
      )
      current_user.update_attributes(stripe_customer_id: stripe_customer.id)
      stripe_subscription = stripe_customer.subscriptions.first
    end

    if stripe_subscription.present?
      @subscription = current_user.subscriptions.new(params[:subscription])
      @subscription.expires_on = Time.at(stripe_subscription.current_period_end).to_date
      @subscription.stripe_subscription_id = stripe_subscription.id
      @subscription.save
      Notifier.delay.subscription_receipt(@subscription)
      Notifier.delay.new_subscription(@subscription)

      return redirect_to root_path, :notice => "Successfully Certified!"
    else
     return redirect_to new_subscription_path, notice: "There was a problem with your subscription. Please try again."
    end
  end
end