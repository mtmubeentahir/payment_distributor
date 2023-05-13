class Order < ApplicationRecord
  belongs_to :merchant, foreign_key: 'merchant_reference', primary_key: 'merchant_reference'
	has_one :disbursment
end
