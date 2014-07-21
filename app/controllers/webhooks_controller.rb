class WebhooksController < ApplicationController
  require 'json'

  def receiver
    data_json = JSON.parse(request.body.read)
    type = data_json['type']
    object = data_json['data']['object']

    if type == "invoice.created"  #http://stackoverflow.com/questions/22082277/stripe-additional-invoice-item-included-on-recurring-payment/22916561#22916561
      stripe_customer_id = object['customer']
      stripe_subscription_id = object['subscription']
      customer = User.find_by_stripe_customer_id(stripe_customer_id)
      if customer.present? && customer.subscriptions.any? && customer.subscriptions.last.expires_on <= Date.today
        last_subscription = customer.subscriptions.last
        # renew subscription
        @subscription = customer.subscriptions.create(plan_id: last_subscription.plan_id, 
                                       stripe_subscription_id: stripe_subscription_id, 
                                                   expires_on: Date.today + 1.month, 
                                               price_in_cents: last_subscription.price_in_cents)
        Notifier.delay.subscription_renewal(@subscription)
      end
    end

    if type == "charge.failed"
      customer = object['customer']

      # suspend subscription
    end

    if type == "charge.dispute.created"
    #   charge_id = data_json['data']['object']['charge']
    #   amount = data_json['data']['object']['amount']
    #   commitment = Commitment.find_by(stripe_charge_id: charge_id)
    #   if commitment.present?
    #     # Automating disputing balance from driver
    #     @driver = commitment.trip.user
    #     @passenger = commitment.user
    #     @driver.balance_in_cents = @driver.balance_in_cents - commitment.amount
    #     @driver.save
        
    #     Notifier.delay.charge_dispute(@driver, @passenger, commitment)
    #     Notifier.delay.admin_charge_dispute(commitment, amount)
    #   end
    end

    render nothing: true
  end
end