class CreateAgesUsersTable < ActiveRecord::Migration
  def self.up
    create_table :ages_users, :id => false do |t|
      t.references :user
      t.references :age
    end
    add_index :ages_users, [:user_id, :age_id]
    add_index :ages_users, [:age_id, :user_id]
  end

  def self.down
    drop_table :ages_users
  end
end