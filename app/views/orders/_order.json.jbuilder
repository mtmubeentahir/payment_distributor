json.extract! order, :id, :merchant_reference, :amount, :created_at, :updated_at
json.url order_url(order, format: :json)
