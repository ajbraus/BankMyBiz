class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  has_many :comments, as: :commentable, dependent: :destroy
  
  attr_accessible :accepted, :body
  acts_as_voteable

  after_save :set_last_touched

  def set_last_touched
    self.post.update_attributes(last_touched_at: Time.now)
  end
end
