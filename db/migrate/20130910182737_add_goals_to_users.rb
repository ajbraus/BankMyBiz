class AddGoalsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :goals, :text
  end
end
