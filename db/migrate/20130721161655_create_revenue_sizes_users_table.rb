class CreateRevenueSizesUsersTable < ActiveRecord::Migration
  def self.up
    create_table :revenue_sizes_users, :id => false do |t|
      t.references :user
      t.references :revenue_size
    end
    add_index :revenue_sizes_users, [:user_id, :revenue_size_id]
    add_index :revenue_sizes_users, [:revenue_size_id, :user_id]
  end

  def self.down
    drop_table :revenue_sizes_users
  end
end