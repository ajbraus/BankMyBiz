ThinkingSphinx::Index.define :post, :with => :active_record do
  indexes :content, as: :post_content
  indexes tags(:name), as: :tag_name
  #indexes happening_on, sortable: true
  #has author_id, published_at
  has created_at
  has bank
  
  set_property :field_weights => {
    :post_title => 5,
    :tag_name => 7
  }
end