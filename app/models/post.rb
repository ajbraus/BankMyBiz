class Post < ActiveRecord::Base
  include PublicActivity::Common
  is_impressionable :counter_cache => true #@post.impressions_count
  #tracked owner: ->(controller, model) { controller && controller.current_user }
  belongs_to :user
  has_many :committed_users, through: :commitments
  has_and_belongs_to_many :tags
  has_many :comments, as: :commentable
  attr_accessible :content,
                  :tag_list

  validates :content, presence: true

  def nice_created_at_date
    created_at.strftime("%b %e, %Y") #May 21, 2010
  end

  def short_content
    if self.content.size >= 50
      self.content.slice(0..50) + "..."
    else
      self.content
    end
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).posts
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def is_committed_to_by?(user)
    return self.committed_user.find_by_committed_user_id(user.id).present?
  end
end
