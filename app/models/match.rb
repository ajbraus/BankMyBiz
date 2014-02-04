class Match < ActiveRecord::Base
  attr_accessible :user_id, :match_id
  
  #default_scope order('created_at DESC')

  belongs_to :user
  validates :user_id, presence: true
  validates :match_id, presence: true
end