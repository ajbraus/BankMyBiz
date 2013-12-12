class CreateLoanSizesUsersTable < ActiveRecord::Migration
  def up
    create_table :loan_sizes_users, :id => false do |t|
      t.references :user
      t.references :loan_size
    end
    add_index :loan_sizes_users, [:user_id, :loan_size_id]
    add_index :loan_sizes_users, [:loan_size_id, :user_id]
  end

  def down
    drop_table :loan_sizes_users
  end
end

