class WelcomeController < ApplicationController
	def index
    @authentications = current_user.authentications if current_user		
	end
  def about
  end
  def how
  end
  def subscribe
    
  end
end
