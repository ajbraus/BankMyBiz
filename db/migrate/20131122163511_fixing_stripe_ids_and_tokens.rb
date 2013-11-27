class FixingStripeIdsAndTokens < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :stripe_customer_token
    add_column :users, :stripe_customer_id, :string
    drop_table :cards
  end
end
