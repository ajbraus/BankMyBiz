class Location < ActiveRecord::Base
  attr_accessible :name
  
  has_and_belongs_to_many :users
  default_scope order('id ASC')
end
