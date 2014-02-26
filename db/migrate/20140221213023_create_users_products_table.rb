class CreateUsersProductsTable < ActiveRecord::Migration
  def self.up
    create_table :products_users, :id => false do |t|
        t.references :user
        t.references :product
    end
    add_index :products_users, [:user_id, :product_id]
    add_index :products_users, [:product_id, :user_id]
  end

  def self.down
    drop_table :products_users
  end
end
