class Product < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  validates :name, presence: true
  attr_accessible :name, :kind
end
