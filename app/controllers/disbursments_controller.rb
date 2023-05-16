class DisbursmentsController < ApplicationController
  def index
   @disbursments = ActiveRecord::Base.connection.exec_query(query).rows
  end

  def process_orders
    DisburseOrdersJob.perform_later
  end

  private
  def query
    "SELECT
      EXTRACT(YEAR FROM o.created_at) AS year,
      Count(d.id) AS ordres,
      SUM(d.merchant_payment) As merchant_payment,
      SUM(o.amount) AS total_order_amount,
      Count(mf.id) AS total_monthly_fee_count,
      SUM(mf.amount) AS total_monthly_fee
    FROM
      orders AS o
    JOIN
      disbursments AS d ON o.id = d.order_id
    LEFT JOIN
      monthly_fees AS mf ON d.id = mf.disbursment_id
    GROUP BY
      year"
  end
end
