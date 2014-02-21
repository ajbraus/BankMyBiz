class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  
  has_and_belongs_to_many :users

  attr_accessible :name

  validates :name, presence: true

  before_create :camelcase

  def camelcase
    self.name = self.name.downcase.tr(" ", "_")
    self.name = self.name.camelize
  end

  def normalize
    self.name = self.name.underscore
    self.name = self.name.titlecase
    return self.name
  end
end
