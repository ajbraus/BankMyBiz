class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :tag_list, :url
  has_many :comments
  #embed :ids, include: true
  #delegate :current_user, to: :scope
  
  def url
    post_url(object)
  end
  
  def attributes
    data = super
    data[:edit_url] = edit_post_url(object) if current_user.admin?
    data
  end
end
