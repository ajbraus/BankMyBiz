ThinkingSphinx::Index.define :post, :with => :active_record do
  indexes :title, as: :post_title
  indexes :content, as: :post_content
  indexes tags(:name), as: :tag_name
  #indexes happening_on, sortable: true
  #has author_id, published_at
  has created_at
  
  set_property :field_weights => {
    :post_title => 5,
    :post_content => 3,
    :tag_name => 8
  }
end