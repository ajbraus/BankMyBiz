class Match < ActiveRecord::Base
  attr_accessible :user_id, :match_id
  
  belongs_to :user
  belongs_to :match, class_name: "User"
  validates :user_id, presence: true
  validates :match_id, presence: true

  after_create :send_notifications

  def send_notifications
    Message.create(
      subject: "Relationship Recommendation: #{self.match.first_name_with_last_initial}, #{self.match.position} at #{self.match.org_name}",
      body: "#{self.user.first_name}," + "\n\n" + 
            "Out of our network #{self.match.first_name_with_last_initial}, #{self.match.position} at #{self.match.org_name} and they have been added to your Relationship Pipeline." + "\n\n" +
            "A little bit about #{self.match.org_name}:" + "\n\n" +
            "#{self.match.bio}" + "\n\n" +
            "Continue the conversation by replying to this secure, private message." + "\n\n" +
            "",
      sender_id: self.match.id,
      receiver_id: self.user.id,
      is_read: false
      )
  end
end