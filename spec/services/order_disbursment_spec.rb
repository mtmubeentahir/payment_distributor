require 'rails_helper'

RSpec.describe OrderDisbursment do
  describe '#call' do
    let!(:merchant1) { FactoryBot.create(:merchant, merchant_reference: 'merchant1') }
    let!(:merchant2) { FactoryBot.create(:merchant, merchant_reference: 'merchant2') }

    let!(:order1) { FactoryBot.create(:order, merchant: merchant1, amount: 49.0) }
    let!(:order2) { FactoryBot.create(:order, merchant: merchant2, amount: 100.0) }
    let!(:order3) { FactoryBot.create(:order, merchant: merchant1, amount: 400.0) }

    before do
      allow(Merchant).to receive(:with_daily_freq).and_return(Merchant.all)
      allow(Merchant).to receive(:with_weekly_freq).and_return(Merchant.all)
      allow(Merchant).to receive(:same_day).and_return(Merchant.all)
    end

    it 'creates disbursments for eligible orders' do
      expect { subject.call }.to change(Disbursment, :count).by(3)
    end

    it 'calculates commission and monthly fee correctly' do
      subject.call
      disbursment1 = order1.disbursment
      disbursment2 = order2.disbursment
      disbursment3 = order3.disbursment

      expect(disbursment1.commission).to eq(0.49)
      expect(disbursment1.merchant_payment).to eq(48.51)
      expect(disbursment1.monthly_fee).to be_nil

      expect(disbursment2.commission).to eq(0.95)
      expect(disbursment2.merchant_payment).to eq(99.05)
      expect(disbursment2.monthly_fee).to be_nil

      expect(disbursment3.commission).to eq(3.4)
      expect(disbursment3.merchant_payment).to eq(396.6)
      # expect(disbursment3.monthly_fee.amount).to eq(50.0)
    end
  end
end