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
  def robot_post
    @post = Post.find(params[:id])
    @next_post = @post.next_post
  end
  def terms
  end
end
