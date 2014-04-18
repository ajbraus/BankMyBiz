class User < ActiveRecord::Base
  # include PublicActivity::Common
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable,  :token_authenticatable, 
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, 
         :invitable

  before_save :generate_auth_token, :set_auth_token_expiration

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
                  :accounts_receivable_ids, 
                  :loan_size_ids,
                  :customer_type_ids,
                  :loan_priority_ids,
                  :loan_purpose_ids,
                  :bio,
                  :linked_in_url, 
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
                  :stripe_customer_id,
                  :two_years,
                  :cred_count,
                  :product_ids,
                  :zip_code,
                  :website_url

  is_impressionable :counter_cache => true, :unique => :user_id

  acts_as_voter
  has_karma(:posts)
  has_karma(:answers)
  has_karma(:comments)

  has_many :subscriptions
  has_many :purchases

  has_many :posts, dependent: :destroy
  has_many :commitments, foreign_key: "committed_user_id", dependent: :destroy
  has_many :committed_tos, through: :commitments, source: "commitment"

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :answers

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
  has_and_belongs_to_many :accounts_receivables
  has_and_belongs_to_many :loan_sizes
  has_and_belongs_to_many :customer_types
  has_and_belongs_to_many :loan_priorities
  has_and_belongs_to_many :loan_purposes

  has_and_belongs_to_many :tags
  has_and_belongs_to_many :products

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                    class_name:  "Relationship",
                                    dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :messages, class_name: "Message", foreign_key: "receiver_id", dependent: :destroy
  has_many :read_messages, class_name: "Message", foreign_key: "receiver_id", conditions: { is_read: true }
  has_many :unread_messages, class_name: "Message", foreign_key: "receiver_id", conditions: { is_read: false }
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy

  has_many :authentications, dependent: :destroy

  has_many :organizations

  has_many :invitations, :class_name => self.to_s, :as => :invited_by

  has_many :milestones, foreign_key: "funder_id"
  has_many :biz_milestones, class_name: "Milestone", foreign_key: "owner_id"

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

  # validates :name, presence: true

  # before_create :skip_confirmation_notification
  before_create :set_username
  after_create :internal_new_user
  after_create :create_welcome_message
  after_create :add_default_profile_elements
  after_invitation_accepted :email_invited_by
  after_invitation_accepted :create_welcome_message
  after_invitation_accepted :set_username

  def set_products
    if !bank? && finished_profile?
      self.products = []
      if  two_years == true && (Age.where("rank > 1") & ages).any? && (RevenueSize.where("rank > 2") & revenue_sizes).any?
        self.products << Product.find_by_name("Term Loan")  
      end
      if two_years == true && (Age.where("rank > 1") & ages).any? && (RevenueSize.where("rank > 2") & revenue_sizes).any?
        self.products << Product.find_by_name("Line of Credit") 
      end
      if (Age.where("rank < 4") & ages).any? && (RevenueSize.where("rank > 1") & revenue_sizes).any?
        self.products << Product.find_by_name("SBA Loan")
      end
      if (AccountsReceivable.where("rank > 2") & accounts_receivables).any?
        self.products << Product.find_by_name("Factoring")
      end
      if (RevenueSize.where("rank > 2") & revenue_sizes).any?
        self.products << Product.find_by_name("Revenue Based") 
      end
      if (RevenueSize.where("rank > 2") & revenue_sizes).any? && Industry.where(id: [5,19,17,21,24,27,6,3,4])
        self.products << Product.find_by_name("Asset Based")
      end
      if (BusinessType.where(id: [6,9,8]) & business_types).any?
        self.products << Product.find_by_name("Community Development Fund")
      end
      if (RevenueSize.where("rank > 2") & revenue_sizes).any?
        self.products << Product.find_by_name("Merchant Cash Advance")
      end
      if (BusinessType.where(id: [6,9,8]) & business_types).any?
        self.products << Product.find_by_name("Grants")
      end
      if (Industry.where(id: [8,14,18,21,24,27]) & industries).any?
        self.products << Product.find_by_name("Crowd Funding for Rewards") 
      end
      if (Industry.where(id: [14,17,19,5,21,13,6,12,3,2,20,31]) & industries).any?
        self.products << Product.find_by_name("Crowd Funding for Equity") 
      end
      if two_years == false && (RevenueSize.where("rank > 1") & revenue_sizes).any? && Industry.where(id: [14,20,13,12])
        self.products << Product.find_by_name("Angel Investment") 
      end
      
      # products << Product.find_by_description("Private Equity") if false # DO NOT ASSIGN
      # products << Product.find_by_description("Cash Advance") if false # DO NOT ASSIGN
      # products << Product.find_by_description("Venture Capital") if false # DO NOT ASSIGN

      # [17, "Agriculture"]
      # [18, "Arts & Design"]
      # [19, "Automotive"]
      # [5, "Construction"]
      # [7, "Consulting"]
      # [21, "Consumer Products"]
      # [13, "Data & Analytics"]
      # [22, "Education"]
      # [24, "Electronics"]
      # [23, "Energy"]
      # [25, "Engineering"]
      # [8, "Entertainment & Media"]
      # [26, "Events"]
      # [27, "Fashion & Apparel"]
      # [1, "Financial Services"]
      # [6, "Food & Beverage"]
      # [28, "Government & Politics"]
      # [12, "Healthcare & Pharma"]
      # [16, "Health & Wellness"]
      # [14, "Internet"]
      # [29, "Legal"]
      # [3, "Manufacturing"]
      # [11, "Nonprofit"]
      # [9, "Real Estate (Com)"]
      # [10, "Real Estate (Res)"]
      # [2, "Retail"]
      # [15, "Sales &  Marketing"]
      # [20, "Science & Biotech"]
      # [30, "Security"]
      # [4, "Transportation & Distribution"]
      # [31, "Travel & Tourism"]

    end
  end

  def near_by_matches
    zip_prefix = self.zip_code[0..2]
    User.where(bank: !self.bank?).where("zip_code LIKE '#{zip_prefix}%'")
  end

  def local?(other_user)
    if self.zip_code.present? && other_user.zip_code.present?
      return self.zip_code[0..2] == other_user.zip_code[0..2]
    end
    return false
  end

  def background_color
    if status == "Actively Looking"
      return "rgba(0, 158, 0, 0.72)"
    elsif status == "Offers Welcome"
      return "rgba(255, 215, 0, 0.6)"
    elsif status == "Just Browsing"
      return "rgba(0, 90, 255, 0.48)"
    else
    end
  end

  def status_class
    if status == "Actively Looking"
      return "text-success"
    elsif status == "Offers Welcome"
      return "text-warning"
    elsif status == "Just Browsing"
      return "text-info"
    else
    end
  end

  def email_invited_by
     inviter = self.invited_by
     inviter.reward_a_match
     Notifier.delay.invitation_accepted(self.invited_by, self)
  end

  def add_default_profile_elements
    customer_types << CustomerType.first(2)
    save
  end

  def reward_a_match
    if self.finished_profile?
      if potential_matches.any?
        matched_users << potential_matches.first
      end
    end
  end

  def to_param
    "#{id} #{username}".parameterize
  end

  def is_a_match_with?(other_user)
    return other_user.in?(self.matched_users)
  end

  def create_welcome_message 
    if self.name.present?
      michael = User.find_by_email("michael@bankmybiz.com")
      if michael.present?
        Message.create(
          subject: "Welcome to Bankmybiz",
          body: "#{self.first_name}," + "\n\n" + 
                "Thanks for joining the Bankmybiz Network where members bank on relationships. Complete your profile to begin to receive matches. Questions are a great way to start a business relationship. Use the Bankmybiz's public Q&A platform to ask questions about your biggest challenges or about how to achieve your biggest goals'." + "\n\n" +
                "The Bankmybiz matching algorithm matches you with people who want to connect with you. Youn can send secure private messages to your matches and followers. You receive one free match a week, but if you want more more, you can purchase matches at a time from your Matches page." + "\n\n" +
                "Post questions and advice to improve your profile and start conversations about your business and expertise. That can lead to lots of valuable connections and relationships." + "\n\n" +
                "There are a few other bells and whistles we home you use such as following users to get notified about their activity, reading and contributing to our blog 'Banking on Relationships.'" + "\n\n\n" +
                "Thanks and again, Welcome!" + "\n\n\n" +
                "Michael Adam, CEO Bankmybiz",
          sender_id: michael.id,
          receiver_id: self.id,
          is_read: false
          )
      end
    end
  end

  # def send_welcome
  #   Notifier.delay.welcome(self)
  # end

  def set_username
    if self.name.present?
      self.username = self.first_name_with_last_initial.split.join('-')[0..-2]
    else
      self.username = self.email.split('@')[0]
    end
  end

  def internal_new_user
    Notifier.delay.internal_new_user(self)
    #Notifier.delay.confirmation_of_request(self)
    # if Rails.env.production?
    #   Message.delay.create(sender_id: User.find_by_email("michael@bankmybiz.com").id, receiver_id: self.id, subject: 'Welcome to Bankmybiz.com', body: "")
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
  end  

  def reneg!(commitment)
    commitments.find(commitment.id).destroy
  end

  def first_name
    @name_array = self.name.split(' ')
    @name_array[0].capitalize
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
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
    if avatar.present? || authentications.first.present?
      return true
    end
    return false
  end

  def profile_picture_url 
    if avatar.present?
      return avatar.url
    elsif authentications.first.present?
      return authentications.first.profile_pic_url
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
      u.rejected_at.blank? && !u.finished_profile? && ( u.created_at.to_date == (Date.today - 8.days) || u.created_at.to_date == (Date.today - 21.days) )
    end
    @users.each do |u|
      Notifier.delay.profile_reminder(u)
    end
  end

  def self.percentage_complete_profiles
    complete_profiles_count = 0
    User.all.each do |u|
      complete_profiles_count += 1 if u.profile_progress_percent == 100
    end
    return complete_profiles_count
  end
  
  def started_profile?
    return profile_progress_percent > 0
  end

  def finished_profile?
    return profile_progress_percent == 100
  end

  def in_same_location?(other_user)
    if self.bank? 
      match_bank = self
      match_biz = other_user
    else
      match_bank = other_user
      match_biz = self
    end

    if match_bank.locations.any? && match_biz.hq_state.present?
      return match_bank.locations.include?(Location.first) || match_bank.hq_state.in?(match_bank.locations)
    end

    return false
  end

  def can_be_matched?
    return (avatar.present? || authentications.first.present?) && profile_progress_percent >= 60
  end

  def profile_questions_completed
    progress = 0

    progress += 1 if accounts_receivables.any?
    progress += 1 if loan_sizes.any?
    progress += 1 if customer_types.any?
    progress += 1 if employee_sizes.any?
    progress += 1 if industries.any?
    progress += 1 if business_types.any?
    progress += 1 if revenue_sizes.any?
    progress += 1 if ages.any?
    progress += 1 if locations.any?
    progress += 1 if position.present?
    progress += 1 if bio.present?
    progress += 1 if goals.present?
    progress += 1 if avatar.present? || authentications.first.present?  
    progress += 1 if org_name.present?
    progress += 1 if hq_state.present?
    progress += 1 if zip_code.present?
    progress += 1 if two_years != nil

    return progress
  end

  def total_profile_elements
    17
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
    if other_user.employee_sizes.any? && employee_sizes.any?
      with_employee_size = (other_user.employee_size_ids & employee_size_ids).present?
    end
    if other_user.revenue_sizes.any? && revenue_sizes.any?
      with_revenue_size = (other_user.revenue_size_ids & revenue_size_ids).present?
    end
    if other_user.business_types.any? && business_types.any?
      with_business_type = (other_user.business_type_ids & business_type_ids).present?
    end
    if other_user.accounts_receivables.any? && accounts_receivables.any?
      with_ar = (other_user.accounts_receivable_ids & accounts_receivable_ids).present?
    end
    if other_user.loan_sizes.any? && loan_sizes.any?
      with_loan_size = (other_user.loan_size_ids & loan_size_ids).present?
    end
    if other_user.customer_types.any? && customer_types.any?
      with_customer_type = (other_user.customer_type_ids & customer_type_ids).present?
    end
  
    percentage_match += 1 if with_age == true
    percentage_match += 1 if with_industry == true
    percentage_match += 1 if with_employee_size == true
    percentage_match += 1 if with_revenue_size == true
    percentage_match += 1 if with_business_type == true
    percentage_match += 1 if with_ar == true
    percentage_match += 1 if with_loan_size == true
    percentage_match += 1 if with_customer_type == true

    return percentage_match * 100 / 8
  end

  def todays_match
    if matches.last.present?
      return matches.last.user
    else
      return User.find_by_email("michael@bankmybiz.com")
    end 
  end

  def todays_peers
    if peered_users.last
      return peered_users.last(3)
    else
      return User.find_by_email("team@bankmybiz.com")
    end 
  end

  def bankable?(other_user)
    if other_user.bank?
      bank = other_user
      biz = self
    else
      bank = self
      biz = other_user
    end
    
    if bank.two_years == false
      return true
    else
      return true if biz.two_years == true
    end
    return false
  end

  def potential_matches
    matchables = User.where("id != ? AND status != ? AND bank != ? ", self.id, "Just Browsing", self.bank)

    matches = matchables.select { |m| m.bankable?(self) &&
                                      m.in_same_location?(self) &&
                                      m.percentage_match(self) > 50 &&
                                      !m.in?(self.matched_users) } 

    return matches
  end

  def set_matches
    if finished_profile? && (matches.none? || matches.last.created_at < 1.week.ago) && potential_matches.any?
      match = potential_matches.first
      matched_users << match
      Notifier.delay.new_match(self, match) if receive_match_messages?
    end
  end

  def set_peers
    if finished_profile? && (peers.none? ||peers.last.created_at < Date.yesterday)
      @available_users = User.all.reject { |r| r == self || r.bank != self.bank || r.in?(self.peered_users) || !r.can_be_matched? }
      @peers = @available_users.select do |s| 

        if s.ages && ages.any?
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
        if s.accounts_receivables.any? && accounts_receivables.any?
          with_ar = (s.accounts_receivable_ids & accounts_receivable_ids).present?
        end
        if s.loan_sizes.any? && loan_sizes.any?
          with_loan_size = (s.loan_size_ids & loan_size_ids).present?
        end
        if s.customer_types.any? && customer_types.any?
          with_customer_type = (s.customer_type_ids & customer_type_ids).present?
        end

        with_age == true ||
        with_industry == true ||
        with_location == true ||
        with_employee_size == true ||
        with_revenue_size == true ||
        with_business_type == true ||
        (with_ar == true && with_customer_type == true) ||
        with_loan_size == true
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
      u.set_matches
      #u.set_peers
    end
  end

  def self.clean_up_peers_and_matches
    User.where(bank: false).each do |u|
      #MATCHES
      u.matches.each do |m|
        if m.created_at < 1.month.ago 
          m.destroy
        end
      end
      #PEERS
      u.peers.each do |p|
        if p.created_at < 1.month.ago
          p.destroy
        end
      end
    end
    User.where(bank: true).each do |u|
      #MATCHES
      u.matches.each do |m|
        if m.created_at < 4.months.ago 
          m.destroy
        end
      end
      #PEERS
      u.peers.each do |p|
        if p.created_at < 4.months.ago
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

  private
  
  def generate_auth_token
    begin
      self.auth_token = SecureRandom.hex
    end while self.class.exists?(auth_token: auth_token)
  end

  def set_auth_token_expiration
    self.auth_token_expires_at = DateTime.now + 60.days
  end
end

