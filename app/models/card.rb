class Card < ActiveRecord::Base
  belongs_to :user
  attr_accessible :card_type, :last_four, :stripe_card_token

  validates :user_id, :card_type, :last_four, :stripe_card_token, presence: true
end
