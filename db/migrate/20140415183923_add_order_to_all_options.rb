class AddOrderToAllOptions < ActiveRecord::Migration
  def change
    add_column :employee_sizes, :rank, :integer
    add_column :business_types, :rank, :integer
    add_column :revenue_sizes, :rank, :integer
    add_column :ages, :rank, :integer
    add_column :accounts_receivables, :rank, :integer
    add_column :loan_sizes, :rank, :integer
    add_column :customer_types, :rank, :integer
    add_column :loan_priorities, :rank, :integer
    add_column :loan_purposes, :rank, :integer

    EmployeeSize.all.each {|e| e.update_attributes(rank: e.id) }
    BusinessType.all.each {|e| e.update_attributes(rank: e.id) }
    RevenueSize.all.each {|e| e.update_attributes(rank: e.id) }
    Age.all.each {|e| e.update_attributes(rank: e.id) }
    AccountsReceivable.all.each {|e| e.update_attributes(rank: e.id) }
    LoanSize.all.each {|e| e.update_attributes(rank: e.id) }
    CustomerType.all.each {|e| e.update_attributes(rank: e.id) }
    LoanPriority.all.each {|e| e.update_attributes(rank: e.id) }
    LoanPurpose.all.each {|e| e.update_attributes(rank: e.id) }
  end
end
