class AddStatusHandelAndHqStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :handle, :string, null: false, default: ""
    add_column :users, :status, :string, null: false, default: "Actively Looking"
    add_column :users, :hq_state, :string, null: false, default: ""
  end
end
