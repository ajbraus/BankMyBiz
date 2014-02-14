ThinkingSphinx::Index.define :post, :with => :active_record do
  indexes :title, as: :post_title
  indexes :content, as: :post_content
  indexes tags(:name), as: :tag_name
  indexes answers(:body), as: :answer_body
  #has author_id, last_touched_at
  has last_touched_at
  has created_at
  
  set_property :field_weights => {
    :tag_name => 8,
    :post_title => 5,
    :post_content => 3,
    :answer_body => 2
  }
end