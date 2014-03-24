class AddProfilePicUrlToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :profile_pic_url, :string

    User.all.each do |u|
      auth = u.authentications.first
      if auth.present?
        auth.profile_pic_url = u.pic_url
        auth.save
        u.pic_url = nil
        u.save
      end
    end
  end
end
