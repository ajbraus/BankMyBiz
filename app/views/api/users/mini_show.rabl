object @user
attributes :id, :name, :position
node(:profile_picture_url) { |u| u.profile_picture_url }