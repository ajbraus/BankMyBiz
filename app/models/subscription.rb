class Subscription < ActiveRecord::Base
  default_scope order('expires_on asc')
  belongs_to :user
  validates_presence_of :user_id, :plan_id, :expires_on, :price
  
  attr_accessible :plan, :stripe_subscription_id, :expires_on, :price

  def expired?
    return expires_on > Date.today
  end
end