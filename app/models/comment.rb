class Comment < ActiveRecord::Base
  include PublicActivity::Common
  # tracked owner: ->(controller, model) { controller && controller.current_user }
  
  belongs_to :commentable, polymorphic: true
  has_many :likes, as: :likeable
  
  attr_accessible :content
  
  def nice_created_at
    self.created_at.strftime "%b %e, %l:%M%P"
  end  

  # private

  # def find_commentable
  #   params.each do |name, value|
  #     if name =~ /(.+)_id$/
  #       return $1.classify.constantize.find(value)
  #     end
  #   end
  #   nil
  # end
  
end
