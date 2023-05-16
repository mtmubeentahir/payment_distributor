require 'csv'


#
#
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
puts "Merchants Loaded"


#
#
# Load All Orders to DB
puts "Orders data is populating and procesing disbursment, Sorry for inconvienence, It might take 3 to 7 minute"
puts "It has to process the 400k records to give you the big data instead of empty project"
orders = []
CSV.foreach("#{Rails.root}/lib/orders.csv", col_sep: ';', headers: true) do |row|
  o_amount = row['amount'].to_f.round(2)
  cmsn = (o_amount < 50 ? o_amount * 0.01 : o_amount >=50 && o_amount < 300 ? o_amount * 0.0095 : o_amount * 0.0085).round(2)

  o = Order.new(merchant_reference: row['merchant_reference'], amount: o_amount, created_at: row['created_at'])
  o.build_disbursment(commission: cmsn, merchant_payment: (o_amount - cmsn).round(2))

  orders << o
end
Order.import(orders,recursive: true, bacth_size: 1000)
puts "Orders Created"


#
#
#Load Monthly Fees to DB
puts "Remaining Monthly Fees are populating"
sql = "SELECT
      EXTRACT(month from o.created_at) AS month,
      EXTRACT(year from o.created_at) AS year,
      o.merchant_reference,
      SUM(d.commission)
    FROM orders AS o
    JOIN disbursments AS d ON d.order_id = o.id
    GROUP  BY o.merchant_reference, month, year
    having SUM(d.commission) > 0.0
    ORDER  BY year, month"
    

data = ActiveRecord::Base.connection.exec_query(sql).rows

merchants = Merchant.includes(:orders)
monthly_fees = []
data.each do |row|
  month_number, year_number, t_cmsn = row[0].to_i, row[1].to_i, row[3].to_f.round(2)
  mer = merchants.find_by(merchant_reference: row[2])

  diff = (mer.minimum_monthly_fee - t_cmsn).round(2)
  next unless diff >0.0

  monthly_fees << {
    amount: diff,
    disbursment_id: mer.orders.where(created_at: Date.new(year_number, month_number, 1).all_month).order(:created_at).first.disbursment.id
  }
end

MonthlyFee.import(monthly_fees, bacth_size: 1000)
puts "Remaining Monthly Fees populated"
