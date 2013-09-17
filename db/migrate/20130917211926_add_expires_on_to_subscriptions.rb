class AddExpiresOnToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :expires_on, :date
  end
end
