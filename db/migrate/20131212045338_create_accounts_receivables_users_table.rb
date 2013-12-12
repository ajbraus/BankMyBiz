class CreateAccountsReceivablesUsersTable < ActiveRecord::Migration
  def up
    create_table :accounts_receivables_users, :id => false do |t|
      t.references :user
      t.references :accounts_receivable
    end
    add_index :accounts_receivables_users, [:user_id, :accounts_receivable_id], name: 'index_ar_users_on_user_id_and_ar_id'
    add_index :accounts_receivables_users, [:accounts_receivable_id, :user_id], name: 'index_ar_users_on_ar_id_and_user_id'
  end

  def down
    drop_table :accounts_receivables_users
  end
end