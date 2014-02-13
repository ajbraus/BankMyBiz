class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  has_many :comments, as: :commentable
  attr_accessible :accepted, :body

  acts_as_voteable
end
