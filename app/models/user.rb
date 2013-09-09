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
                  :avatar,
                  :confirmed_at,
                  :location_ids,
                  :org_name,
                  :position
                  
  is_impressionable

  acts_as_voter
  has_karma(:posts)
  has_karma(:comments)

  has_many :subscriptions

  has_many :posts, dependent: :destroy
  has_many :commitments, foreign_key: "committed_user_id", dependent: :destroy
  has_many :committed_tos, through: :commitments, source: "commitment"

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :matches, foreign_key: "match_id", dependent: :destroy
  has_many :matched_users, through: :matches, source: :user

  has_many :peers, foreign_key: "peer_id", dependent: :destroy
  has_many :peered_users, through: :peers, source: :user

  has_many :likes

  has_and_belongs_to_many :employee_sizes
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :business_types
  has_and_belongs_to_many :revenue_sizes
  has_and_belongs_to_many :ages
  has_and_belongs_to_many :locations

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

  validates :avatar, # :attachment_presence => true,
                     :attachment_content_type => { :content_type => [ 'image/png', 'image/jpg', 'image/gif', 'image/jpeg' ] }

  validates :name, presence: true

  before_create :skip_confirmation_notification
  after_create :request_confirmation

  # def send_welcome
  #   Notifier.delay.welcome(self)
  # end

  def request_confirmation
    Notifier.delay.internal_new_user(self)
    Notifier.delay.confirmation_of_request(self)
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
    if employee_sizes.any? && business_types.any? && industries.any? && revenue_sizes.any? && ages.any? && bio.present?
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

  def todays_matches
    if matched_users.last
      return matched_users.last(1)
    else
      return User.find_by_email("michael@bankmybiz.com")
    end 
  end

  def todays_peers
    if peered_users.last
      return peered_users.last(3)
    else
      return User.find_by_email("michael@bankmybiz.com")
    end 
  end

  def set_peers_and_matches
    #MATCHES
    if matches.none? || matches.last.created_at < Date.yesterday
      @available_users = User.all.reject { |r| r == self || r.bank == self.bank || r.in?(self.matched_users) }
      @matches = @available_users.select do |s| 
        if s.ages.any? && ages.any?
          with_age = (s.age_ids & age_ids).present?
        end
        if s.industries && industries.any?
          with_industry = (s.industry_ids & industry_ids).present?
        end
        if s.locations.any? && locations.any?
          with_location = (s.location_ids & location_ids).present?
        end
        if s.employee_sizes.any? && employee_sizes.any?
          with_employee_size = (s.employee_size_ids & employee_size_ids).present?
        end
        if s.revenue_sizes.any? && revenue_sizes.any?
          with_revenue_size = (s.revenue_size_ids & revenue_size_ids).present?
        end
        if s.business_types.any? && business_types.any?
          with_business_type = (s.business_type_ids & business_type_ids).present?
        end

        with_age == true ||
        with_industry == true ||
        with_location == true ||
        with_employee_size == true ||
        with_revenue_size == true ||
        with_business_type == true
      end
    end
  
    self.matched_users << @matches.first if @matches.present?

    #PEERS
    if peers.none? ||peers.last.created_at < Date.yesterday
      @available_users = User.all.reject { |r| r == self || r.bank != self.bank || r.in?(self.peered_users) }
      @peers = @available_users.select do |s| 
        if s.ages.any? && ages.any?
          with_age = (s.age_ids & age_ids).present?
        end
        if s.industries && industries.any?
          with_industry = (s.industry_ids & industry_ids).present?
        end
        if s.locations.any? && locations.any?
          with_location = (s.location_ids & location_ids).present?
        end
        if s.employee_sizes.any? && employee_sizes.any?
          with_employee_size = (s.employee_size_ids & employee_size_ids).present?
        end
        if s.revenue_sizes.any? && revenue_sizes.any?
          with_revenue_size = (s.revenue_size_ids & revenue_size_ids).present?
        end
        if s.business_types.any? && business_types.any?
          with_business_type = (s.business_type_ids & business_type_ids).present?
        end

        with_age == true ||
        with_industry == true ||
        with_location == true ||
        with_employee_size == true ||
        with_revenue_size == true ||
        with_business_type == true
      end

      if @peers.count >= 3
       peered_users << @peers.first(3) 
      elsif @peers.count == 2
       peered_users << @peers.first(2) 
      elsif @peers.count == 1
       peered_users << @peers.first 
      end
    end
  end

  def self.set_peers_and_matches
    User.all.each do |u|
      u.set_peers_and_matches
    end
  end

  def self.clean_up_peers_and_matches
    User.all.each do |u|
      #MATCHES
      u.matches.each do |m|
        if m.created_at < 6.months.ago 
          m.destroy
        end
      end
      #PEERS
      u.peers.each do |p|
        if p.created_at < 6.months.ago
          p.destroy
        end
      end
    end
  end
end

