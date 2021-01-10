# frozen_string_literal: true

RSpec.describe ShoppingCart::PromotionalRule::Factory do

  describe 'self.#for' do
    subject { described_class.for(rule_name, arguments) }

    describe 'DiscountOnTotalByAmountSpentRule' do
      let(:arguments) { { spent: 50, discount: 10 } }
      let(:rule_name) { :discount_on_total_by_amount_spent }

      it 'returns a new instance of DiscountOnTotalByAmountSpentRule with'\
        'valid paremeters' do

        expect(subject).to be_instance_of(
          ShoppingCart::PromotionalRule::DiscountOnTotalByAmountSpentRule
        )
        expect(subject.arguments[:spent]).to eq(50)
        expect(subject.arguments[:discount]).to eq(10)
      end
    end

    describe 'DiscountOnItemPriceByUnitsRule' do
      let(:mask) { Product.new(code: '001', name: 'FPP3 mask', price: 9.5) }
      let(:arguments) { { units: 2, price: 8.25, product: mask } }
      let(:rule_name) { :discount_on_item_price_by_units }

      it 'returns a new instance of DiscountOnItemPriceByUnitsRule with'\
        'valid paremeters' do

        expect(subject).to be_instance_of(
          ShoppingCart::PromotionalRule::DiscountOnItemPriceByUnitsRule
        )
        expect(subject.arguments[:units]).to eq(2)
        expect(subject.arguments[:price]).to eq(8.25)
        expect(subject.arguments[:product]).to eq(mask)
      end
    end

    describe 'BaseRule' do
      let(:rule_name) { nil }

      subject { described_class.for(rule_name) }

      it 'returns a new instance of BaseRule when rule name is nil' do
        expect(subject).to be_instance_of(
          ShoppingCart::PromotionalRule::BaseRule
        )
      end
    end
  end
end
