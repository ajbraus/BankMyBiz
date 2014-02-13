class Post < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :user
  has_many :committed_users, through: :commitments
  has_and_belongs_to_many :tags

  is_impressionable :counter_cache => true

  has_many :answers
  
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable


  acts_as_voteable
  
  attr_accessible :title,
                  :content,
                  :tag_list

  validates :content, presence: true

  after_create :increment_tag_use_count

  def increment_tag_use_count
    tags.each do |t|
      t.use_count += 1
      t.save
    end
  end

  def nice_created_at_date
    created_at.strftime("%b %e, %Y") #May 21, 2010
  end

  def short_content
    if self.content.size >= 140
      self.content.slice(0..140) + "..."
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

  def next_post
    self.class.first(:conditions => ["id > ?", id])
  end

  def rebuild_index
    rake fs:rebuild
  end
end
