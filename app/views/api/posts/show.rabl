object @post
attributes :id, :content, :tag_list
node(:vote_count) { |p| p.plusminus }
node(:profile_image_url) { |p| p.user.profile_picture_url }

child(:user) { attributes :id, :first_name_with_last_initial }

child(:comments) do 
  attributes :id, :content
  node(:vote_count) { |c| c.plusminus }

  child(:user) { attributes :first_name_with_last_initial }
end