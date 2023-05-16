require 'rails_helper'

RSpec.describe CompanyCommission, type: :service do
  describe '.calculate' do
    context 'when amount < 0' do
      it 'returns 0.0' do
        expect(CompanyCommission.calculate(-2)).to eq(0.0)
      end
    end

    context 'when amount > 0 && amount < 50' do
      it 'calculates commission as 1.00 %' do
        amount = 22
        expected_commission = (amount * CompanyCommission::FIRST_PERCENT).round(2)
        expect(CompanyCommission.calculate(amount)).to eq(expected_commission)
      end
    end

    context 'when amount >= 50 && amount < 300' do
      it 'calculates commission 0.95%' do
        amount = 100
        expected_commission = (amount * CompanyCommission::SECOND_PERCENT).round(2)
        expect(CompanyCommission.calculate(amount)).to eq(expected_commission)
      end
    end

    context 'when amount >=  300' do
      it 'calculates commission 0.85%' do
        amount = 300
        expected_commission = (amount * CompanyCommission::THIRD_PERCENT).round(2)
        expect(CompanyCommission.calculate(amount)).to eq(expected_commission)
      end
    end
  end
end
