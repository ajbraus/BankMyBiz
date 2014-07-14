object false

child @products do
  attributes :id, :name
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @employee_sizes do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @industries do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @business_types do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @revenue_sizes do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @ages do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @locations do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @accounts_receivables do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @loan_sizes do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @customer_types do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @loan_priorities do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end

child @loan_purposes do
  attributes :id, :description
  node(:banker_count) { |p| p.users.where(bank: true).where('status != ?', "Just Browsing").count }
  node(:business_count) { |p| p.users.where(bank: false).where('status != ?', "Just Browsing").count }
end
