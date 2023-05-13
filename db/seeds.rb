require 'csv'

# Load All Merchants to DB
puts "Merchants data is populating"
merchants = []
CSV.foreach("#{Rails.root}/lib/merchants.csv", col_sep: ';', headers: true) do |row|
  merchants << {
    merchant_reference: row['reference'],
    email: row['email'],
    live_on: row['live_on'],
    frequency: Merchant.frequencies[row['disbursement_frequency']],
    minimum_monthly_fee: row['minimum_monthly_fee'],
  }
end
Merchant.import(merchants)

#
#
# Load All Orders to DB
puts "Orders data is populating"
orders = []
CSV.foreach("#{Rails.root}/lib/orders.csv", col_sep: ';', headers: true) do |row|
  orders << {
    merchant_reference: row['merchant_reference'],
    amount: row['amount'].to_f.round(2),
    created_at: row['created_at']
  }
end
Order.import(orders, bacth_size: 1000)
puts "Data Loaded"
