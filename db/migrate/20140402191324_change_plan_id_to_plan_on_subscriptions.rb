class ChangePlanIdToPlanOnSubscriptions < ActiveRecord::Migration
  def change
    change_column :subscriptions, :plan_id, :string
    rename_column :subscriptions, :plan_id, :plan

    add_column :subscriptions, :stripe_subscription_id, :string
    remove_column :subscriptions, :price
  end
end
