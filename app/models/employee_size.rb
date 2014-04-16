class EmployeeSize < ActiveRecord::Base
  has_and_belongs_to_many :users 
  
  attr_accessible :description, :rank
  default_scope order('rank ASC')
end
