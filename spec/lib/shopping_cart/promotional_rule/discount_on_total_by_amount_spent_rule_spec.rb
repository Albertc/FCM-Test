# frozen_string_literal: true

RSpec.describe ShoppingCart::PromotionalRule::DiscountOnTotalByAmountSpentRule do
  let(:arguments) { { spent: 50, discount: 10 } }

  subject { described_class.new(arguments).total(total_amount) }

  describe '#total' do
    context 'when the total spent does not exceed arguments[:spent]' do
      let(:total_amount) { 40 }

      it 'returns 0 percentage to apply' do
        is_expected.to eq(0)
      end
    end

    context 'when the total spent exceeds arguments[:spent]' do
      let(:total_amount) { 60 }

      it 'returns the <arguments[:discount]> percentage of the total_amount' do
        is_expected.to eq(6)
      end
    end
  end
end
