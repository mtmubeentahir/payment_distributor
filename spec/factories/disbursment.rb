FactoryBot.define do
  factory :disbursment do
    commission { 1.0 }
    merchant_payment { 100.0 }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
  