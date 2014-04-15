class CreateLoanPurposesUsersTable < ActiveRecord::Migration
  def self.up
    create_table :loan_purposes_users, :id => false do |t|
      t.references :user
      t.references :loan_purpose
    end
    add_index :loan_purposes_users, [:user_id, :loan_purpose_id]
    add_index :loan_purposes_users, [:loan_purpose_id, :user_id]
  end

  def self.down
    drop_table :loan_purposes_users
  end
end