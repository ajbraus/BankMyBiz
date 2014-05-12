class Match < ActiveRecord::Base
  attr_accessible :user_id, :match_id
  
  belongs_to :user
  validates :user_id, presence: true
  validates :match_id, presence: true
end