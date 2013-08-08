class User < ActiveRecord::Base
  include PublicActivity::Common
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

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
                  :terms,
                  :admin,
                  :avatar
                  
  # attr_accessible :title, :body

  is_impressionable

  has_many :posts, dependent: :destroy
  has_many :commitments, foreign_key: "committed_user_id", dependent: :destroy
  has_many :committed_tos, through: :commitments, source: "commitment"

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comments

  has_many :likes

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

  has_many :authentications, dependent: :destroy

  has_attached_file :avatar,
         :styles => { 
            :medium => "200x200",
            :thumb => "100x100#" 
            },
         :convert_options => { 
            :thumb => '-quality 60 -strip' 
            },
         :storage => :s3,
         :s3_credentials => { :access_key_id => ENV['S3_ACCESS_KEY'], :secret_access_key => ENV['S3_SECRET_KEY'], :bucket => "bankmybiz"},
         :path => "user_avatars/:id/avatar.:extension",
         :default_url => "https://s3.amazonaws.com/bankmybiz/default_avatar.png"


  validates :name, presence: true

  # has_attached_file :avatar, :styles => { :original => "150x150#",
  #                                         :raster => "50x50#" },
  #                            :convert_options => { :raster => '-quality 30' },
  #                            :storage => :s3,
  #                            :s3_credentials => S3_CREDENTIALS,
  #                            :path => "user/:attachment/:style/:id.:extension",
  #                            :default_url => "https://s3.amazonaws.com/bmb-production/user/avatars/original/default_profile_pic.png"
  
  before_create :skip_confirmation_notification
  after_create :request_confirmation

  # def send_welcome
  #   Notifier.delay.welcome(self)
  # end

  def request_confirmation
    Notifier.delay.request_confirmation(self)
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

  def nice_created_at
    created_at.strftime("%b %e, %Y") #May 21, 2010
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
    other_user.create_activity :follow, owner: self
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def messages_left?
    if messages.any?
      if messages.last.created_at < 1.day.ago
        return true
      end
    else
      return true
    end
    return false
  end

  def has_image?
    if avatar.present? || pic_url.present?
      return true
    end
    return false
  end

  def skip_confirmation_notification
    skip_confirmation_notification!
  end
end
