object @post
attributes :id, :content, :tag_list
node(:vote_count) { |p| p.plusminus }

#if current_user.admin?
 # node(:edit_url) { |article| edit_article_url(article) }
 # node(:delete_url) { |article| destroy_article_url(article) }
#end

child(:user) { attributes :id, :first_name_with_last_initial }

child(:comments) do 
  attributes :id, :content
  node(:vote_count) { |c| c.plusminus }

  child(:user) { attributes :first_name_with_last_initial }
end