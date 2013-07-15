class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :bank_type, 
                  :bio, 
                  :business_type, 
                  :city, 
                  :email, 
                  :existing_loans, 
                  :industries, 
                  :name, 
                  :owner, 
                  :owners_count, 
                  :phone, 
                  :size_cash, 
                  :size_employees, 
                  :state,
                  :years_old

  serialize :industries
  #Profile.new(:industries => ["Blah", "Blerg", "Derk"])
end
