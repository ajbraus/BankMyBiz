class Post < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  acts_as_voteable
  
  attr_accessible :title,
                  :content,
                  :slug,
                  :tag_list,
                  :impressions_count,
                  :last_touched_at

  validates :title, :content, :slug, presence: true

  after_create :increment_tag_use_count
  before_save :set_last_touched

  extend FriendlyId
  friendly_id :title, use: :slugged

  # def should_generate_new_friendly_id?
  #   new_record?
  # end

  def send_update_to_tag_followers(current_user)
    tags.each do |t|
      t.users.each do |u|
        unless u == current_user
          Notifier.delay.tag_follower_update(u, t, self)
        end
      end
    end
  end

  def set_last_touched
    last_touched_at = Time.now
  end

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
