class Subscription < ActiveRecord::Base
  default_scope order('expires_on asc')
  belongs_to :user
  validates_presence_of :user_id, :plan_id, :expires_on, :price
  
  attr_accessible :plan_id, :stripe_card_id, :expires_on, :price
end