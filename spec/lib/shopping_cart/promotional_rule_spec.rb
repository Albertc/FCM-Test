# frozen_string_literal: true

RSpec.describe ShoppingCart::PromotionalRule do
  describe '#new' do
    let(:arguments) { { price: 8.25, quantity: 5 } }
    let(:name) { :discount_test_name }

    subject(:promotional_rule) { described_class.new(name, arguments) }

    it 'returns an instance of PromotionalRule params provided' do
      expect(promotional_rule.name).to eq(:discount_test_name)
      expect(promotional_rule.arguments).to eq({ price: 8.25, quantity: 5 })
    end
  end
end
