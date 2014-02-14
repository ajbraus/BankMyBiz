object current_user
attributes :id, :name, :authentication_token, :bio, :impressions_count, :org_name, :position, :goals, 
                :newsletter, :receive_match_messages
node(:cred_count) { |u| u.cred_count }
node(:profile_picture_url) { |u| u.profile_picture_url }
node(:matches_count) { |u| u.matches.count }