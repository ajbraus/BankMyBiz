class Subscription < ActiveRecord::Base
  default_scope order('expires_on asc')
  belongs_to :user
  validates_presence_of :user_id, :plan_id, :plan_id, :stripe_card_token, :expires_on
  
  attr_accessible :plan_id, :stripe_card_token
  
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(description:user.email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
end