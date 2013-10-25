object @activity
attributes :id, :trackable_type, :trackable_id
node(:time_ago_in_words) do |activity| 
  time_ago_in_words(activity.created_at)
end

node(:trackable_content) do |activity|
  if activity.trackable_type == "User"
    "Interacted with" + " " + activity.trackable.first_name_with_last_initial
  else
    "Posted to the News Feed:" + " " + activity.trackable.content 
  end
end