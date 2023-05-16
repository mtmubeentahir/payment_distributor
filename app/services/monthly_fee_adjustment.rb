class MonthlyFeeAdjustment
  attr_reader :adjust_commision

  def initialize(merchant, order)
    @merchant = merchant.reload
    @order = order
    @adjust_commision = 0.0
  end

  def call
    return @adjust_commision if @order.created_at.month == @merchant.live_on.month

    check_commission_adjustment if DateTime.now.mday == 1 || first_order_of_month?
    @adjust_commision.round(2)
  end

  private

  def first_order_of_month?
    !@merchant.orders.joins(:disbursment).where('orders.created_at >= ?', @order.created_at.beginning_of_month).any?
  end

  def check_commission_adjustment
    diff = @merchant.minimum_monthly_fee - lsat_month_commission
    @adjust_commision = diff > 0.0 ? diff : 0.0
  end

  def lsat_month_commission
    orders = @merchant.orders.joins(:disbursment)
    last_order_date = orders.order("orders.created_at").last.created_at
    orders.where(orders: { created_at: last_order_date.all_month}).pluck(:commission).sum.round(2)
  end

  # def lsat_month_commission
  #   @merchant
  #     .orders
  #     .joins(:disbursment)
  #     .where(orders: { created_at: @order.created_at.last_month.all_month}).pluck(:commission).sum.round(2)
  # end
end
