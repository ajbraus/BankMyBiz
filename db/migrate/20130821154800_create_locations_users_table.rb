class CreateLocationsUsersTable < ActiveRecord::Migration
  def self.up
    create_table :locations_users, :id => false do |t|
      t.references :user
      t.references :location
    end
    add_index :locations_users, [:user_id, :location_id]
    add_index :locations_users, [:location_id, :user_id]
  end

  def self.down
    drop_table :locations_users
  end
end
