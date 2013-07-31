class Message < ActiveRecord::Base
  attr_accessible :body, :is_read, :receiver_id, :sender_id, :subject

  belongs_to :receiver, class_name: "User"
  belongs_to :sender, class_name: "User"

  def nice_created_at
    created_at.strftime("%l:%M%p %b %e, %y") #May 21, 10
  end

end
