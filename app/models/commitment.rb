class Commitment < ActiveRecord::Base
#  include PublicActivity::Common
  
  attr_accessible :commitment_id
  
  belongs_to :committed_user, class_name: "User"
  belongs_to :commitment, class_name: "Post"

  validates :committed_user_id, presence: true
  validates :commitment_id, presence: true    
end