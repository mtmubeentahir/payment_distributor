class DisbursmentsController < ApplicationController
  def index
   @disbursments = ActiveRecord::Base.connection.exec_query(query).rows
  end

  def process_orders
    DisburseOrdersJob.perform_later
  end

  private
  def query
    sql = "SELECT
      EXTRACT(year from o.created_at) AS year, 
      Count(d.id),
      SUM(d.merchant_payment),
      SUM(o.amount),
      Count(m.id),
      SUM(m.amount)
    FROM  orders AS o
    JOIN disbursments AS d ON d.order_id = o.id
    LEFT JOIN monthly_fees AS m ON m.disbursment_id = d.id
    GROUP  BY year"
  end
end

# Order.
    #   left_joins(disbursment: :monthly_fee).
    #   group("to_char(orders.created_at, 'YYYY')").
    #   pluck("
    #     Count(disbursments.id),
    #     SUM(disbursments.merchant_payment),
    #     sum(orders.amount),
    #     Count(monthly_fee.id),
    #     sum(monthly_fee.amount)"
    #   )