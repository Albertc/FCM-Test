# frozen_string_literal: true

RSpec.describe ShoppingCart::PromotionalRule::DiscountOnItemPriceByUnitsRule do
  let(:arguments) { { price: 8.25, units: 5 } }
  let(:price) { 7.5 }

  subject { described_class.new(arguments).total(quantity, price) }

  describe '#total' do
    context 'when the quantity bought does not exceed arguments[:units]' do
      let(:quantity) { 4 }

      it 'returns the quantity * price' do
        is_expected.to eq(30)
      end
    end

    context 'when the quantity bought exceeds arguments[:units]' do
      let(:quantity) { 10 }

      it 'returns the quantity * price of the rule (arguments[:price])' do
        is_expected.to eq(82.5)
      end
    end
  end
end
