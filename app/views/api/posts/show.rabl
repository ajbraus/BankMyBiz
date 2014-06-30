object @post
attributes :id, :content, :tag_list
node(:vote_count) { |p| p.plusminus }
node(:answers_count) { |p| p.answers.count }
node(:impressions_count) { |p| p.impressions_count }

child(:user) do 
  attributes :id, :first_name_with_last_initial
  node(:profile_image_url) { |u| u.profile_picture_url }
end

child(:comments) do 
  attributes :id, :content
  node(:vote_count) { |c| c.plusminus }

  child(:user) { attributes :id, :first_name_with_last_initial }
end