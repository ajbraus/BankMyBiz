class AddTimeStampsToSubscriptions < ActiveRecord::Migration
  def change
    change_table(:subscriptions) { |t| t.timestamps }
  end
end
