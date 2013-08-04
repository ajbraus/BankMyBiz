class User < ActiveRecord::Base
  include PublicActivity::Common
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, 
                  :password, 
                  :password_confirmation, 
                  :remember_me, 
                  :name, 
                  :bank, 
                  :employee_size_ids,
                  :revenue_size_ids,
                  :age_ids,
                  :business_type_ids,
                  :industry_ids,
                  :bio,
                  :linked_in_url, 
                  :pic_url, 
                  :location,
                  :terms
                  
  # attr_accessible :title, :body

  is_impressionable

  has_many :posts, dependent: :destroy
  has_many :commitments, foreign_key: "committed_user_id", dependent: :destroy
  has_many :committed_tos, through: :commitments, source: "commitment"

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes

  has_many :profiles

  has_and_belongs_to_many :employee_sizes
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :business_types
  has_and_belongs_to_many :revenue_sizes
  has_and_belongs_to_many :ages

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                    class_name:  "Relationship",
                                    dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :messages, class_name: "Message", foreign_key: "receiver_id"
  has_many :read_messages, class_name: "Message", foreign_key: "receiver_id", conditions: { is_read: true }
  has_many :unread_messages, class_name: "Message", foreign_key: "receiver_id", conditions: { is_read: false }
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"

  has_many :authentications

  validates :name, presence: true

  # has_attached_file :avatar, :styles => { :original => "150x150#",
  #                                         :raster => "50x50#" },
  #                            :convert_options => { :raster => '-quality 30' },
  #                            :storage => :s3,
  #                            :s3_credentials => S3_CREDENTIALS,
  #                            :path => "user/:attachment/:style/:id.:extension",
  #                            :default_url => "https://s3.amazonaws.com/bmb-production/user/avatars/original/default_profile_pic.png"
  
  # after_create :send_welcome

  def send_welcome
    Notifier.welcome(self).deliver
  end

  def nice_name
    @name_array = self.name.split(' ')
    @name_array.each { |n| n.capitalize }
  end

  def first_name
    @name_array = self.name.split(' ')
    @name_array[0].capitalize
  end

  def first_name_with_last_initial
    @name_array = self.name.split(' ')
    @name_array[0].capitalize + " " + @name_array.last.capitalize.slice(0) + "."
  end

  def last_name
    @name_array = self.name.split(' ')
    @name_array.last
  end

  def middle_name
    self.name.split.count > 3 ? self.name.split(' ')[1] : nil
  end

  def committed_to?(post)
    return commitments.find_by_commitment_id(post.id).present?
  end
  
  def commit!(post)
    @commitment = commitments.create!(commitment_id: post.id)
    @commitment.create_activity :create, owner: current_user
  end  

  def reneg!(commitment)
    commitments.find(commitment.id).destroy
  end

  def started_profile?
    if employee_sizes.any? || business_types.any? || industries.any? || revenue_sizes.any? || ages.any?
      return true
    end
  end

  def finished_profile?
    if employee_sizes.any? && business_types.any? && industries.any? && revenue_sizes.any? && ages.any?
      return true
    end
  end

  def first_name
    @name_array = self.name.split(' ')
    @name_array[0].capitalize
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
    #maybe needed to create virtual attributes to accept the form and create associations?
      #   t.string :business_type
      # t.text :industries
      # t.string :years_old
      # t.string :size_revenue
      # t.string :size_employees
end
