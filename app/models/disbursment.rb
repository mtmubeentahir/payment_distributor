class Disbursment < ApplicationRecord
  belongs_to :order
  has_one :monthly_fee
end
