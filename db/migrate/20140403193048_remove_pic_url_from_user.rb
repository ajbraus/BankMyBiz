class RemovePicUrlFromUser < ActiveRecord::Migration
  def change
    User.where("pic_url IS NOT NULL").each do |u|
      auth = u.authentications.first
      auth.profile_pic_url = u.pic_url
      auth.save
    end

    remove_column :users, :pic_url
  end
end
