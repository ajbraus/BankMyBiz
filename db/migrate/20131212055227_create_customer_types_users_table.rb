class CreateCustomerTypesUsersTable < ActiveRecord::Migration
  def up
    create_table :customer_types_users, :id => false do |t|
      t.references :user
      t.references :customer_type
    end
    add_index :customer_types_users, [:user_id, :customer_type_id]
    add_index :customer_types_users, [:customer_type_id, :user_id]
  end

  def down
    drop_table :customer_types_users
  end
end
