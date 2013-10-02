class AddRecieveMatchMessagesToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_match_messages, :boolean, default: true
  end
end
