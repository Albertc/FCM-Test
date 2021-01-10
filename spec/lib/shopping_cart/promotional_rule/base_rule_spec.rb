# frozen_string_literal: true

RSpec.describe ShoppingCart::PromotionalRule::BaseRule do
  let(:arguments) { { price: 8.25, units: 5 } }

  describe '#new' do
    subject { described_class.new(arguments) }

    it 'returns an instance of BaseRule with the arguments provided' do
      expect(subject.arguments[:price]).to eq(8.25)
      expect(subject.arguments[:units]).to eq(5)
    end
  end

  describe '#total' do
    let(:quantity) { 7 }
    let(:price) { 3.45 }

    subject { described_class.new(arguments).total(quantity, price) }

    it 'returns the quantity * price' do
      is_expected.to eq(24.15)
    end
  end
end
