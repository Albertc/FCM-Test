# frozen_string_literal: true

RSpec.describe ShoppingCart::BasketItemCreator do

  describe '#call' do
    subject { described_class.new(items, product).call }

    shared_examples 'not adding new items into items array' do
      it 'does not change items array size' do
        expect { subject }.not_to(change { items.size })
      end
    end

    context 'with valid parameters' do
      let(:product) { Product.new(code: '001', name: 'FPP3 mask', price: 9.5) }
      let(:items) { [] }

      context 'when the product exists in the received items array' do
        let(:item) { ShoppingCart::Basket::BasketItem.new(product) }

        before { items << item }

        it_behaves_like 'not adding new items into items array'

        it 'returns the item found' do
          expect(subject).to eq(item)
        end
      end

      context 'when the product does not exist in the received items array' do
        it 'change the items array size' do
          expect { subject }.to(change { items.size }.by(1))
        end

        it 'adds in items array a new BasketItem object with valid data' do
          subject

          expect(items.last).to be_instance_of(ShoppingCart::Basket::BasketItem)
          expect(items.last.product).to eq(product)
          expect(items.last.quantity).to eq(0)
        end
      end
    end

    context 'when the product parameter is invalid' do
      let(:product) { '001' }
      let(:items) { [] }

      it { is_expected.to be_nil }

      it_behaves_like 'not adding new items into items array'
    end

    context 'when the items array parameter is invalid' do
      let(:product) { Product.new(code: '001', name: 'FPP3 mask', price: 9.5) }
      let(:items) { nil }

      it { is_expected.to be_nil }
    end
  end
end
