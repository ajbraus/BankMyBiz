class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
  end

  User.all.each do |u|
    u.username = u.first_name_with_last_initial.split.join('-')[0..-2]
    u.save
  end
end

