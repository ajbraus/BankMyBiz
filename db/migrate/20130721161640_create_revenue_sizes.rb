class CreateRevenueSizes < ActiveRecord::Migration
  def change
    create_table :revenue_sizes do |t|
      t.string :description

      t.timestamps
    end
    RevenueSize.create(description: "$0 - $100k")    
    RevenueSize.create(description: "$100k - $1M")    
    RevenueSize.create(description: "$1M - $5M")    
    RevenueSize.create(description: "$5M - 10M")    
    RevenueSize.create(description: "$10M +")    
  end
end
