class CreateLoanPrioritiesUsersTable < ActiveRecord::Migration
  def self.up
    create_table :loan_priorities_users, :id => false do |t|
      t.references :user
      t.references :loan_priority
    end
    add_index :loan_priorities_users, [:user_id, :loan_priority_id]
    add_index :loan_priorities_users, [:loan_priority_id, :user_id]
  end

  def self.down
    drop_table :loan_priorities_users
  end
end