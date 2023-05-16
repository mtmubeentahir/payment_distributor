FactoryBot.define do
  factory :order do
    merchant_reference { 'John' }
    amount { 100.0 }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
