class Subscription < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :plan_id
  
  attr_accessible :plan_id
  
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(description:email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  end
end