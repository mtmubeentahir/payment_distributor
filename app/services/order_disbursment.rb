class OrderDisbursment
  def call
    merchants.each do |mer|
      orders.each do |order|
        order_amount = order.amount.to_f.round(2)
        next if order.disbursment

        create(
          order, order_amount,
          CompanyCommission.calculate(order_amount),
          MonthlyFeeAdjustment.new(mer, order).call
        )
      end 
    end
  end

  private
  def merchants
    Merchant.with_daily_freq.or(Merchant.with_weekly_freq.same_day).includes(:orders)
  end

  def orders(mer)
    mer.orders.includes(:disbursment).where(disbursment: {order_id: nil})
  end

  def create(order, order_amount, commission, monthly_fee)
    merchant_payment = (order_amount - commission).round(2)
    ActiveRecord::Base.transaction do
      dis = order.create_disbursment(commission: commission, merchant_payment: merchant_payment)
      dis.create_monthly_fee(amount: monthly_fee) if monthly_fee > 0.0
    end
  end
end
