class Merchant < ApplicationRecord
	has_many :orders, foreign_key: 'merchant_reference', primary_key: 'merchant_reference'

	enum :frequency, { DAILY: 1, WEEKLY: 2 } 

	scope :with_daily_freq, -> { where(frequency: frequencies['DAILY']) }
	scope :with_weekly_freq, -> { where(frequency: frequencies['WEEKLY']) }
	scope :same_day, -> { where("to_char(live_on,'D') = ?", (DateTime.now.strftime('%w').to_i + 1).to_s) }

	# def ready_to_disburse?
  #   frequency.DAILY? || (frequency.WEEKLY? && frequency.live_on.wday == DateTime.now.wday)
  # end

	# def first_order_of_month?
	# 	orders.joins(:disbursment).where('orders.created_at >= ?', Time.now.utc.beginning_of_month).any?
	# 	@merchant.orders.joins(:disbursment).where('orders.created_at >= ?', @order.created_at.beginning_of_month).any?
	# end

	# def previous_month_orders
	# 	start_of_month = Time.now.utc.last_month.beginning_of_month
	# 	end_of_month = start_of_month.end_of_month
	# 	orders.where('created_at >= ? and created_at <= ?', start_of_month , end_of_month)
	# end
end
