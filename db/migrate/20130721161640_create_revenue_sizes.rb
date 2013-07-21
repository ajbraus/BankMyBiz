class CreateRevenueSizes < ActiveRecord::Migration
  def change
    create_table :revenue_sizes do |t|
      t.string :description

      t.timestamps
    end
    RevenueSize.create(description: "$0-$100k")    
    RevenueSize.create(description: "$100k-$1m")    
    RevenueSize.create(description: "$1m-$5m")    
    RevenueSize.create(description: "$5m-10m")    
    RevenueSize.create(description: "$10M and Above")    
  end
end
