class AddStatusHandelAndHqStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :handle, :string
    add_column :users, :status, :string, default: "Actively Looking"
  end
end
