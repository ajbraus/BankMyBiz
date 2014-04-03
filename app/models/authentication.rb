class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :profile_pic_url

  validates :uid, :provider, :profile_pic_url, presence: true
end
