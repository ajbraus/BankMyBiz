object @user
attributes :id, :name, :bio, :impressions_count, :position,
           :org_name, :position, :goals, :newsletter, :receive_match_messages, :two_years, :hq_state

node(:industries) { |u| u.industries.map(&:description).join(', ')}
node(:locations) { |u| u.locations.map(&:name).join(', ')}
node(:ages) { |u| u.ages.map(&:description).join(', ')}
node(:customer_types) { |u| u.customer_types.map(&:description).join(', ')}
node(:business_types) { |u| u.business_types.map(&:description).join(', ')}
node(:accounts_receivables) { |u| u.accounts_receivables.map(&:description).join(', ')}
node(:employee_sizes) { |u| u.employee_sizes.map(&:description).join(', ')}
node(:revenue_sizes) { |u| u.revenue_sizes.map(&:description).join(', ')}

node(:cred_count) { |u| u.cred_count }
node(:profile_picture_url) { |u| u.profile_picture_url }
node(:matches_count) { |u| u.matches.count }
node(:milestones_count) { |u| u.posts.count }

child(:posts) do 
  extends "api/posts/show"
end
