class Comment < ActiveRecord::Base
#  include PublicActivity::Common
  # tracked owner: ->(controller, model) { controller && controller.current_user }  
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  acts_as_voteable
  
  attr_accessible :content

  validates :commentable_id, :commentable_type, :content, presence: true
  
  before_save :set_last_touched

  def set_last_touched
    if self.commentable_type == "Post"
      self.commentable.update_attributes(last_touched_at: Time.now)
    end
  end

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
