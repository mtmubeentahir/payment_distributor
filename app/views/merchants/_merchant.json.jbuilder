json.extract! merchant, :id, :merchant_reference, :email, :live_on, :frequency, :minimum_monthly_fee, :created_at, :updated_at
json.url merchant_url(merchant, format: :json)
