# frozen_string_literal: true

RSpec.describe ShoppingCart::Basket::BasketItem do
  describe '#new' do
    let(:product) { Product.new(code: '001', name: 'FPP3 mask', price: 9.5) }

    subject { described_class.new(product) }

    it 'returns an instance of BasketItem with the product provided' do
      expect(subject.product).to eq(product)
    end

    it 'returns an instance of BasketItem with zero quantity' do
      expect(subject.quantity).to eq(0)
    end
  end
end
