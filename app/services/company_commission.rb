class CompanyCommission
  FIRST_PERCENT = 0.01
  SECOND_PERCENT = 0.0095
  THIRD_PERCENT = 0.0085

  def self.calculate(_amount)
    amount = _amount.to_f
    return if amount < 0

    res = if amount < 50
            amount * FIRST_PERCENT
          elsif amount  >= 50 && amount < 300
            amount * SECOND_PERCENT
          else
            amount * THIRD_PERCENT
          end
    res.round(2)
  end
end
