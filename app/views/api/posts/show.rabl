object @post
attributes :id, :title, :content, :tag_list
node(:vote_count) { |p| p.plusminus }
node(:answers_count) { |p| p.answers.count }
node(:impressions_count) { |p| p.impressions_count }
node(:created_at_ago) { |p| time_ago_in_words(p.created_at) }

child(:user) do 
  attributes :id, :first_name_with_last_initial, :org_name, :position, :hq_state
  node(:profile_image_url) { |u| u.profile_picture_url }
  node(:milestones_count) { |u| u.posts.count }
end

child(:comments) do 
  attributes :id, :content
  node(:vote_count) { |c| c.plusminus }
  node(:created_at_ago) { |c| time_ago_in_words(c.created_at) }

  child(:user) do
    attributes :id, :first_name_with_last_initial, :location, :position, :org_name
    node(:profile_image_url) { |u| u.profile_picture_url }
    node(:milestones_count) { |u| u.posts.count }
    node(:cred_count) { |u| u.cred_count }
  end
end

child(:answers) do
  attributes :id, :body, :accepted
  node(:vote_count) { |a| a.plusminus }
  node(:created_at_ago) { |a| time_ago_in_words(a.created_at) }
  
  child(:user) do
    attributes :id, :first_name_with_last_initial, :location, :position, :org_name
    node(:profile_image_url) { |u| u.profile_picture_url }
    node(:milestones_count) { |u| u.posts.count }
    node(:cred_count) { |u| u.cred_count }
  end

  child(:comments) do 
    attributes :id, :content
    node(:vote_count) { |c| c.plusminus }
    node(:created_at_ago) { |c| time_ago_in_words(c.created_at) }

    child(:user) do
      attributes :id, :first_name_with_last_initial, :location, :position, :org_name
      node(:profile_image_url) { |u| u.profile_picture_url }
      node(:milestones_count) { |u| u.posts.count }
      node(:cred_count) { |u| u.cred_count }
    end
  end
end
