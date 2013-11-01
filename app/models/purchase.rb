class Purchase < ActiveRecord::Base
  belongs_to :user
  attr_accessible :coupon_code, :match_count, :price

  validates :user_id, :match_count, :price, presence: true

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
