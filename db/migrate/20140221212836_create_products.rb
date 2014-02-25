class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false, default: "", index:true

      t.timestamps
    end
    Product.create(name: "Term Loan")
    Product.create(name: "Line of Credit")
    Product.create(name: "SBA Loan")
    
    Product.create(name: "Factoring")
    Product.create(name: "Revenue Based")
    Product.create(name: "Asset Based")
    Product.create(name: "Private Equity")
    Product.create(name: "Community Development Fund")
    Product.create(name: "Merchant Services")
    Product.create(name: "Cash Advance")
    Product.create(name: "Grants")
    Product.create(name: "Crowd Funding for Rewards") 
    
    Product.create(name: "Crowd Funding for Equity") 
    Product.create(name: "Angel Investment")
    Product.create(name: "Venture Capital")
  end
end
