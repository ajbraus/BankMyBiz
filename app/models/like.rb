class Like < ActiveRecord::Base
  attr_accessible :likeable_id, :likeable_type

  belongs_to :likeable, polymorphic: true
  belongs_to :user
end
