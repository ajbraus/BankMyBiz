class Milestone < ActiveRecord::Base
  attr_accessible :details, :products, :owner_id, :purpose, :size, :funder_id
  belongs_to :funder, class_name: "User"
  belongs_to :owner, class_name: "User"

  validates :funder_id, :owner_id, :products, presence: true
end
