class WelcomeController < ApplicationController
  def new_ad
    
  end
	def index
    @authentications = current_user.authentications if current_user		
	end
  def about
  end

  def team
  end
  
  def how
  end
  
  def subscribe
  end

  def terms
  end
  
  def privacy
    
  end

  def testimonials 

  end
end
