class CreateEmployeeSizesUsersTable < ActiveRecord::Migration
  def self.up
    create_table :employee_sizes_users, :id => false do |t|
      t.references :user
      t.references :employee_size
    end
    add_index :employee_sizes_users, [:user_id, :employee_size_id]
    add_index :employee_sizes_users, [:employee_size_id, :user_id]
  end

  def self.down
    drop_table :employee_sizes_users
  end
end