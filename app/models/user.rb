class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :posts
  has_many :commitments, foreign_key: "committed_user_id", dependent: :destroy

  has_many :comments, as: :commentable
  has_many :check_ins, as: :checkinable

  def committed_to?(post)
    return commitments.find_by_commitment_id(post.id).present?
  end
  
  def commit!(post)
    commitments.create!(commitment_id: post.id)
  end  

  def reneg!(post)
    commitments.find_by_commitment_id(commitment_id: post.id).destroy
  end
end
