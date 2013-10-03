collection @activities
attributes :id, :trackable_type, :trackable_id
node(:time_ago_in_words) { object.created_at.time_ago_in_words }

if object.trackable_type = "Comment"
  node(:trackable_content) { object.trackable.content }
elsif object.trackable_type = "Post" 
  node(:trackable_content) { object.trackable.title }
elsif object.trackable_type = "User"
  node(:trackable_content) { object.trackable.user.first_name_with_last_initial }  
end

