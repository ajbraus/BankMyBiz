class AddCredCountCacheCounterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cred_count, :integer, default: 100
  end
end
