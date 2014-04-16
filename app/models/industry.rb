class Industry < ActiveRecord::Base
  has_and_belongs_to_many :users
  attr_accessible :description
  
  default_scope order('description ASC')
end
