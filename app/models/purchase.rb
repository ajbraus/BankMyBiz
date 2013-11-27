class Purchase < ActiveRecord::Base
  belongs_to :user
  attr_accessible :coupon_code, :match_count, :price

  validates :user_id, :match_count, :price, presence: true
end
