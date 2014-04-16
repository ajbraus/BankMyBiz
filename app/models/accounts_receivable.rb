class AccountsReceivable < ActiveRecord::Base
  attr_accessible :description, :rank
  
  has_and_belongs_to_many :users
  default_scope order('rank ASC')
end
