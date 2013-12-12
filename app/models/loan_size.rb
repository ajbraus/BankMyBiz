class LoanSize < ActiveRecord::Base
  attr_accessible :description
  
  has_and_belongs_to_many :users
  default_scope order('id ASC')
end
