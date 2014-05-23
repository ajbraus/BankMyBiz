class Subscription < ActiveRecord::Base
  default_scope order('expires_on asc')
  belongs_to :user
  validates_presence_of :user_id, :plan_id, :expires_on, :price_in_cents
  
  attr_accessible :plan_id, :stripe_subscription_id, :expires_on, :price_in_cents

  def expired?
    return expires_on > Date.today
  end
  def name
    if plan_id == "1"
      "Three Months"
    elsif plan_id == "2"
      "Six Months"
    elsif plan_id == "3"
      "Year"
    elsif plan_id == "4"
      "Charter One Month"
    end
  end
end