object @user
attributes :id, :name, :position, :org_name, :hq_state
node(:profile_picture_url) { |u| u.profile_picture_url }