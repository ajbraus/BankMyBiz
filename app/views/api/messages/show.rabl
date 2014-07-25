object @message
attributes :id, :subject, :body, :is_read

node(:sender_id) { |m| m.sender_id }
node(:sender_name) { |m| m.sender.first_name_with_last_initial }
node(:receiver_id) { |m| m.receiver_id }
node(:receiver_name) { |m| m.receiver.first_name_with_last_initial }
node(:profile_picture_url) { |m| m.sender.profile_picture_url }