class User < ActiveRecord::Base
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
                  :bio
  # attr_accessible :title, :body

  has_many :posts
  has_many :commitments, foreign_key: "committed_user_id", dependent: :destroy
  has_many :committed_tos, through: :commitments, source: "commitment"

  has_many :comments, as: :commentable

  has_many :profiles

  has_and_belongs_to_many :employee_sizes
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :business_types
  has_and_belongs_to_many :revenue_sizes
  has_and_belongs_to_many :ages

  acts_as_voter
  has_karma(:comments)

  validates :name, presence: true

  # has_attached_file :avatar, :styles => { :original => "150x150#",
  #                                         :raster => "50x50#" },
  #                            :convert_options => { :raster => '-quality 30' },
  #                            :storage => :s3,
  #                            :s3_credentials => S3_CREDENTIALS,
  #                            :path => "user/:attachment/:style/:id.:extension",
  #                            :default_url => "https://s3.amazonaws.com/bmb-production/user/avatars/original/default_profile_pic.png"


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

  def first_name
    @name_array = self.name.split(' ')
    @name_array[0].capitalize
  end

    #maybe needed to create virtual attributes to accept the form and create associations?
      #   t.string :business_type
      # t.text :industries
      # t.string :years_old
      # t.string :size_revenue
      # t.string :size_employees
end
