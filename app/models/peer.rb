class Peer < ActiveRecord::Base
  attr_accessible :user_id, :peer_id

  belongs_to :user
  validates :user_id, presence: true
  validates :peer_id, presence: true
end
