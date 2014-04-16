class AddRankToProducts < ActiveRecord::Migration
  def change
    add_column :products, :rank, :integer

    Product.all.each {|e| e.update_attributes(rank: e.id) }
  end
end
