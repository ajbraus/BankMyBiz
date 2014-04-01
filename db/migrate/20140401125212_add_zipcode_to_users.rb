class AddZipcodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zip_code, :string, limit: 10
  end
end
