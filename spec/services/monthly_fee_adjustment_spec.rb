require 'rails_helper'

RSpec.describe MonthlyFeeAdjustment do
  let(:merchant) { FactoryBot.create(:merchant) }
  let(:order) { FactoryBot.create(:order, merchant: merchant) }
  let(:adjustment) { MonthlyFeeAdjustment.new(merchant, order) }

  describe '#call' do
    context 'when the order is from the current month' do
      it 'returns 0.0' do
        expect(adjustment.call).to eq(0.0)
      end
    end

    context 'when it is the first order of the month' do
      before do
        allow(adjustment).to receive(:first_order_of_month?).and_return(true)
        allow(adjustment).to receive(:lsat_month_commission).and_return(100.0)
      end

      it 'calculates the commission adjustment' do
        expect(adjustment.call).to eq(50.0) # Assuming minimum_monthly_fee is 150.0
      end
    end

    context 'when it is not the first order of the month' do
      before do
        allow(adjustment).to receive(:first_order_of_month?).and_return(false)
        allow(adjustment).to receive(:lsat_month_commission).and_return(100.0)
      end

      it 'returns 0.0' do
        expect(adjustment.call).to eq(0.0)
      end
    end
  end
end