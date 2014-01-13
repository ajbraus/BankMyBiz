class AddTwoYearsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :two_years, :boolean, default: false
  end
end
