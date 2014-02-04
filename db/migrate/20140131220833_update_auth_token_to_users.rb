class UpdateAuthTokenToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :authentication_token
    add_column :users, :auth_token, :string, index: true, unique:true
    add_column :users, :auth_token_expires_at, :datetime

    User.all.each do |u|
      u.auth_token = SecureRandom.hex
      u.auth_token_expires_at = DateTime.now + 60.days
      u.save
    end

    change_column :users, :auth_token, :string, null: false
    change_column :users, :auth_token_expires_at, :datetime, null: false
  end
end
