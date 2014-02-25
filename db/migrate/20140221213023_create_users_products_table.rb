class CreateUsersProductsTable < ActiveRecord::Migration
  def self.up
    create_table :users_products, :id => false do |t|
        t.references :user
        t.references :product
    end
    add_index :users_products, [:user_id, :product_id]
    add_index :users_products, [:product_id, :user_id]
  end

  def self.down
    drop_table :users_products
  end
end
