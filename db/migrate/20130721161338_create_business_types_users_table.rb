class CreateBusinessTypesUsersTable < ActiveRecord::Migration
  def self.up
    create_table :business_types_users, :id => false do |t|
      t.references :user
      t.references :business_type
    end
    add_index :business_types_users, [:user_id, :business_type_id]
    add_index :business_types_users, [:business_type_id, :user_id]
  end

  def self.down
    drop_table :business_types_users
  end
end