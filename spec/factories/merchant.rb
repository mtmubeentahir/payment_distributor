FactoryBot.define do
  factory :merchant do
    merchant_reference { "John" }
    email { 'example@gmail.com' }
    live_on { '2022-12-09' }
    frequency { Merchant.frequencies['DAILY'] }
    minimum_monthly_fee { 150 }
  end
end
