#  Calculate the commision if the last month minimum threshold does not meet.

# On the first disbursement of each month, we have to ensure the minimum_monthly_fee for the previous month was reached.
# The minimum_monthly_fee ensures that seQura earns at least a given amount for each merchant.

# When a merchant generates less than the minimum_monthly_fee of orders’ commissions in the previous month,
# we will charge the amount left, up to the minimum_monthy_fee configured, as “monthly fee”.
# Nothing will be charged if the merchant generated more fees than the minimum_monthly_fee.

class MonthlyFeeAdjustment
  attr_reader :adjust_commision

  def initialize(merchant, order)
    @merchant = merchant.reload
    @order = order
    @adjust_commision = 0.0
  end

  def call
    return @adjust_commision if @order.created_at.month == @merchant.live_on.month

    check_commission_adjustment if first_order_of_month?
    @adjust_commision.round(2)
  end

  private

  def first_order_of_month?
    !@merchant.orders.joins(:disbursment).where('orders.created_at >= ?', @order.created_at.beginning_of_month).any?
  end

  def check_commission_adjustment
    res = lsat_month_commission
    return 0.0 if res == 'No Previous Data'

    diff = @merchant.minimum_monthly_fee - res 
    @adjust_commision = diff > 0.0 ? diff : 0.0
  end

  def lsat_month_commission
    orders = @merchant.orders.joins(:disbursment)
    # Added this check as i dont have data in CSV for lsat 2 months so when i create new user it picks the last month data
    # So this will consider the last order month as last month
    # in real scenatio i believe it wont be the case 
    # but if you want to charge the free month then the below commented code can full fill the scenario
    last_order_date = orders.order("orders.created_at").last&.created_at

    return 'No Previous Data' unless last_order_date  # just to handle safe case
    
    orders.where(orders: { created_at: last_order_date.all_month}).pluck(:commission).sum.round(2)
  end

  # def lsat_month_commission
  #   @merchant
  #     .orders
  #     .joins(:disbursment)
  #     .where(orders: { created_at: @order.created_at.last_month.all_month}).pluck(:commission).sum.round(2)
  # end
end
