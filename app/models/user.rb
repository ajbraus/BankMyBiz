class User < ActiveRecord::Base
  include PublicActivity::Common
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, 
         :token_authenticatable, :invitable

  before_save :ensure_authentication_token
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, 
                  :password, 
                  :password_confirmation, 
                  :remember_me, 
                  :name, 
                  :username,
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
                  :position,
                  :goals,
                  :newsletter,
                  :receive_match_messages,
                  :status,
                  :hq_state,
                  :stripe_customer_id

  is_impressionable

  acts_as_voter
  has_karma(:posts)
  has_karma(:comments)

  has_many :subscriptions
  has_many :purchases

  has_many :posts, dependent: :destroy
  has_many :commitments, foreign_key: "committed_user_id", dependent: :destroy
  has_many :committed_tos, through: :commitments, source: "commitment"

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :matches, foreign_key: "match_id", dependent: :destroy
  has_many :matched_users, through: :matches, source: :user

  has_many :peers, foreign_key: "peer_id", dependent: :destroy
  has_many :peered_users, through: :peers, source: :user

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
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy

  has_many :authentications, dependent: :destroy

  has_many :organizations

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

  #before_create :skip_confirmation_notification
  before_create :set_username
  after_create :internal_new_user

  def to_param
    "#{id} #{username}".parameterize
  end

  # def send_welcome
  #   Notifier.delay.welcome(self)
  # end

  def set_username
    self.username = self.first_name_with_last_initial.split.join('-')[0..-2]
  end

  def internal_new_user
    Notifier.delay.internal_new_user(self)
    #Notifier.delay.confirmation_of_request(self)
    # if Rails.env.production?
    #   Message.delay.create(sender_id: User.find_by_email("michael@bankmybiz.com").id, receiver_id: self.id, subject: 'Welcome to BankmyBiz.com', body: "")
    # end
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

  def nice_confirmed_at
    confirmed_at.strftime("%b %e, %Y") #May 21, 2010
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
    return profile_progress_percent > 0
  end

  def finished_profile?
    return profile_progress_percent == 100
  end

  def can_be_matched?
    return (avatar.present? || pic_url.present?) && profile_progress_percent >= 60
  end

  def profile_questions_completed
    progress = 0
    progress += 1 if employee_sizes.any?
    progress += 1 if industries.any?
    progress += 1 if business_types.any?
    progress += 1 if revenue_sizes.any?
    progress += 1 if ages.any?
    progress += 1 if locations.any?
    progress += 1 if position.present?
    progress += 1 if bio.present?
    progress += 1 if goals.present?
    progress += 1 if avatar.present? || pic_url.present?  
    progress += 1 if org_name.present?
    progress += 1 if hq_state.present?

    return progress
  end

  def total_profile_elements
    12
  end

  def profile_progress_percent
    profile_questions_completed * 100 / total_profile_elements
  end

  def profile_elements_left
    total_profile_elements - profile_questions_completed
  end

  def local_capital?(other_user)
    return self.hq_state == other_user.hq_state
  end

  def percentage_match(other_user)
    percentage_match = 0

    if other_user.ages.any? && ages.any?
      with_age = (other_user.age_ids & age_ids).present?
    end
    if other_user.industries && industries.any?
      with_industry = (other_user.industry_ids & industry_ids).present?
    end
    if bank? #IF MATCHING WITH BANKS PIC A BUSINESS WITH A HQ IN A STATE THE BANK DOES BUSINESS
      if other_user.locations.any? && hq_state.present?
        with_location = true if locations.include?(Location.first) || other_user.hq_state.in?(locations)
      end
    else #IF MATCHING A BUSINESS, CHOOSE A BANK THAT DOES BUSINESS IN ANY STATE THEY DO BUSINESS
      if other_user.hq_state.present? && locations.present?
        with_location = true if other_user.locations.include?(Location.first) || hq_state.in?(other_user.locations)
      end
    end
    if other_user.employee_sizes.any? && employee_sizes.any?
      with_employee_size = (other_user.employee_size_ids & employee_size_ids).present?
    end
    if other_user.revenue_sizes.any? && revenue_sizes.any?
      with_revenue_size = (other_user.revenue_size_ids & revenue_size_ids).present?
    end
    if other_user.business_types.any? && business_types.any?
      with_business_type = (other_user.business_type_ids & business_type_ids).present?
    end

    percentage_match += 1 if with_age == true
    percentage_match += 1 if with_industry == true
    percentage_match += 1 if with_location == true
    percentage_match += 1 if with_employee_size == true
    percentage_match += 1 if with_revenue_size == true
    percentage_match += 1 if with_business_type == true

    return percentage_match * 100 / 6
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
    Notifier.delay.new_follower(self, other_user)
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

  def profile_picture_url 
    if avatar.present?
      return avatar.url
    elsif pic_url.present?
      return pic_url
    end
  end

  def skip_confirmation_notification
    skip_confirmation_notification!
  end

  def has_active_subscription?
    return subscriptions.any? && subscriptions.first.expires_on > Date.today
  end

  def self.send_profile_reminders
    @users = User.select do |u| 
      u.rejected_at.blank? && !u.started_profile? && ( u.created_at.to_date == (Date.today - 8.days) || u.created_at.to_date == (Date.today - 21.days) )
    end
    @users.each do |u|
      Notifier.delay.profile_reminder(u)
    end
  end

  def todays_matches
    if matched_users.last
      return matched_users.last(1)
    else
      return User.find_by_email("team@bankmybiz.com")
    end 
  end

  def todays_peers
    if peered_users.last
      return peered_users.last(3)
    else
      return User.find_by_email("team@bankmybiz.com")
    end 
  end

  def potential_matches
    available_users = User.all.reject { |r| r == self || r.bank == self.bank || r.in?(self.matched_users) || !r.can_be_matched? }
    matches = available_users.select do |s|
      percentage_match(s) >= 40
    end
    return matches
  end

  def set_peers_and_matches
    #MATCHES
    if self.finished_profile? && (self.matches.none? || self.matches.last.created_at < 1.week.ago)
      matched_users << potential_matches.first if potential_matches.any?
      if self.receive_match_messages?
        Notifier.delay.new_match(self, matched_users.last)
      end
    end

    #PEERS
    if self.finished_profile? && (peers.none? ||peers.last.created_at < Date.yesterday)
      @available_users = User.all.reject { |r| r == self || r.bank != self.bank || r.in?(self.peered_users) || !r.can_be_matched? }
      @peers = @available_users.select do |s| 
        if s.ages.any? && ages.any?
          with_age = (s.age_ids & age_ids).present?
        end
        if s.industries && industries.any?
          with_industry = (s.industry_ids & industry_ids).present?
        end
        if s.locations.any? && locations.any?
          with_location = s.hq_state == hq_state
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
    User.where(bank: false).each do |u|
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
    User.where(bank: true).each do |u|
      #MATCHES
      u.matches.each do |m|
        if m.created_at < 1.year.ago 
          m.destroy
        end
      end
      #PEERS
      u.peers.each do |p|
        if p.created_at < 1.year.ago
          p.destroy
        end
      end
    end
  end

  def add_to_mc_lists
    if Rails.env.production?
      gb = Gibbon::API.new
      list_id = gb.lists.list({:filters => {:list_name => "BMB Users"}})["data"][0]["id"]
      groupings_id = gb.lists.interest_groupings(id: list_id)[0]["id"]
      if bank?
        gb.lists.subscribe({:id => list_id,
                             :email => {:email => self.email},
                             :merge_vars => {:FNAME => self.first_name,
                                             :LNAME => self.last_name,
                                             :groupings => [{:id => "#{groupings_id}",
                                                             :groups => ["Bankers"]
                                                           }]
                                            },
                             :double_optin => false,
                             :send_welcome => false,
                             :update_existing => true})
      else
        gb.lists.subscribe({:id => list_id,
                             :email => {:email => self.email},
                             :merge_vars => {:FNAME => self.first_name,
                                             :LNAME => uselflast_name,
                                             :groupings => [{:id => "#{groupings_id}",
                                                             :groups => ["Businesses"]
                                                           }]
                                            },
                             :double_optin => false,
                             :send_welcome => false,
                             :update_existing => true})
      end
    end
  end

  def self.add_all_users_to_mc
    if Rails.env.production?
      gb = Gibbon::API.new
      list_id = gb.lists.list({:filters => {:list_name => "BMB Users"}})["data"][0]["id"]
      groupings_id = gb.lists.interest_groupings(id: list_id)[0]["id"]
      User.all.each do |u|
        if u.bank?
          gb.lists.subscribe({:id => list_id,
                               :email => {:email => u.email},
                               :merge_vars => {:FNAME => u.first_name,
                                               :LNAME => u.last_name,
                                               :groupings => [{:id => "#{groupings_id}",
                                                               :groups => ["Bankers"]
                                                             }]
                                              },
                               :double_optin => false,
                               :send_welcome => false,
                               :update_existing => true})
        elsif !u.bank?
          gb.lists.subscribe({:id => list_id,
                               :email => {:email => u.email},
                               :merge_vars => {:FNAME => u.first_name,
                                               :LNAME => u.last_name,
                                               :groupings => [{:id => "#{groupings_id}",
                                                               :groups => ["Businesses"]
                                                             }]
                                              },
                               :double_optin => false,
                               :send_welcome => false,
                               :update_existing => true})
        else
          gb.lists.subscribe({:id => list_id,
                               :email => {:email => u.email},
                               :merge_vars => {:FNAME => u.first_name,
                                               :LNAME => u.last_name,
                                               :groupings => [{:id => "#{groupings_id}",
                                                               :groups => ["Undecided"]
                                                             }]
                                              },
                               :double_optin => false,
                               :send_welcome => false,
                               :update_existing => true})
        end
        gb.lists.subscribe({:id => list_id,
                             :email => {:email => u.email},
                             :merge_vars => {:FNAME => u.first_name,
                                             :LNAME => u.last_name,
                                             :groupings => [{:id => "#{groupings_id}",
                                                             :groups => ["Newsletter"]
                                                           }]
                                            },
                             :double_optin => false,
                             :send_welcome => false,
                             :update_existing => true})
      end
    end
  end

  # def add_to_mc_newsletter
  #   if Rails.env.production?
  #     gb = Gibbon::API.new
  #     list_id = gb.lists.list({:filters => {:list_name => "BMB Users"}})["data"][0]["id"]
  #     groupings_id = gb.lists.interest_groupings(id: list_id)[0]["id"]

  #     gb.lists.subscribe({:id => list_id,
  #                          :email => {:email => self.email},
  #                          :merge_vars => {:FNAME => self.first_name,
  #                                          :LNAME => self.last_name,
  #                                          :groupings => [{:id => "#{groupings_id}",
  #                                                          :groups => ["Newsletter"]
  #                                                        }]
  #                                         },
  #                          :double_optin => false,
  #                          :send_welcome => false,
  #                          :update_existing => true})
  #   end
  # end
end

