class DisburseOrdersJob < ApplicationJob
  def perform
    puts "DisburseOrdersJob started."
    OrderDisbursment.new.call
    puts "DisburseOrdersJob completed."
  end
end
