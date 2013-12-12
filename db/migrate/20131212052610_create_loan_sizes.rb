class CreateLoanSizes < ActiveRecord::Migration
  def change
    create_table :loan_sizes do |t|
      t.string :description

      t.timestamps
    end
    LoanSize.create(description: "$25k - $100k")
    LoanSize.create(description: "$100k - $250k")
    LoanSize.create(description: "$250k - $500k")
    LoanSize.create(description: "$500k - $1M")
    LoanSize.create(description: "$1M - $5M")
    LoanSize.create(description: "$5M +")
  end
end
