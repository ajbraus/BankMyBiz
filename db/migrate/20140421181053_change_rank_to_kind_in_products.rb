class ChangeRankToKindInProducts < ActiveRecord::Migration
  def change
    remove_column :products, :rank
    add_column :products, :kind, :string, index:true

    Product.all.each do |p|
      p.kind = "Non-Traditional"
      p.save
    end
    
    Product.create(name: "Deposits", kind:"Traditional")
    Product.create(name: "Credit Cards", kind: "Traditional")
    Product.create(name: "Equipment Loan", kind: "Non-Traditional")
  end
end
