class AddWebsiteAndCityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :website_url, :string
    add_column :users, :city, :string
  end
end
