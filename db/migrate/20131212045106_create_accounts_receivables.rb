class CreateAccountsReceivables < ActiveRecord::Migration
  def change
    create_table :accounts_receivables do |t|
      t.string :description

      t.timestamps
    end
    AccountsReceivable.create(description: "Low")    
    AccountsReceivable.create(description: "Medium")    
    AccountsReceivable.create(description: "High")    
    AccountsReceivable.create(description: "Very High")    
  end
end
