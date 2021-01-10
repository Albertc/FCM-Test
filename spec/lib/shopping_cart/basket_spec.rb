# frozen_string_literal: true

RSpec.describe ShoppingCart::Basket do
  let(:mask) { Product.new(code: '001', name: 'FPP3 mask', price: 9.5) }
  let(:suit_case) { Product.new(code: '002', name: 'suit case ', price: 44.0) }
  let(:pillow) { Product.new(code: '003', name: 'travel pillow', price: 14.9) }
  let(:smartbox) { Product.new(code: '004', name: 'Hotel smartbox', price: 8) }

  let(:promotional_rule_on_total) do
    ShoppingCart::PromotionalRule.new(:discount_on_total_by_amount_spent,
                                      spent: 60,
                                      discount: 10)
  end
  let(:promotional_rule_on_mask) do
    ShoppingCart::PromotionalRule.new(:discount_on_item_price_by_units,
                                      units: 2,
                                      price: 8.25,
                                      product: mask)
  end
  let(:promotional_rules) do
    [promotional_rule_on_total, promotional_rule_on_mask]
  end

  describe '#new' do
    subject { described_class.new(promotional_rules) }

    it 'returns a Basket object with valid attributes' do
      expect(subject.instance_variable_get('@promotional_rules'))
        .to eq(promotional_rules)
      expect(subject.instance_variable_get('@items')).to eq([])
    end
  end

  describe '#add' do
    let(:basket) { described_class.new(promotional_rules) }

    context 'with an invalid product paramater' do
      subject { basket.add('001') }

      it { is_expected.to be_nil }

      it 'does not add anything in the items array' do
        expect { subject }.not_to(change { basket.instance_variable_get('@items').size })
      end
    end

    context 'with a valid product paramater' do
      def add_a_mask
        basket.add(mask)
      end

      def add_a_pillow
        basket.add(pillow)
      end

      subject { add_a_mask }

      context 'when the product does not exist in basket' do
        it 'adds a new BasketItem in the the items array with valid attributes' do
          expect { subject }.to(change { basket.instance_variable_get('@items').size }.by(1))

          new_item = basket.instance_variable_get('@items').last
          expect(new_item).to be_instance_of(ShoppingCart::Basket::BasketItem)
          expect(new_item.quantity).to eq(1)
          expect(new_item.product).to eq(mask)
        end

        it 'returns the quantity of the item in the basket' do
          expect(subject).to be(1)
        end
      end

      context 'when the product exists in basket' do
        it 'updates the basket item quantity attribute' do
          add_a_mask
          basket_item = basket.instance_variable_get('@items').last
          expect(basket_item.quantity).to eq(1)
          add_a_mask
          expect(basket_item.quantity).to eq(2)
        end

        it 'returns the quantity of the item in the basket' do
          expect(add_a_mask).to be(1)
          expect(add_a_mask).to be(2)
          expect(add_a_pillow).to be(1)
          expect(add_a_mask).to be(3)
        end
      end
    end
  end

  describe '#total' do
    subject { basket.total }

    shared_examples 'returning valid result' do |result|
      it { is_expected.to eq(result) }
    end

    context 'without promotional rules' do
      let(:basket) { described_class.new }

      before do
        basket.add(mask)
        basket.add(smartbox)
        basket.add(mask)
        basket.add(mask)
        basket.add(pillow)
      end

      it_behaves_like 'returning valid result', 51.4
    end

    context 'with product promotional rules' do
      let(:basket) { described_class.new([promotional_rule_on_mask]) }

      describe 'discount on item price by units rule' do
        context 'when the quantity bought exceeds the rule units' do
          before do
            basket.add(mask)
            basket.add(mask)
            basket.add(mask)
            basket.add(pillow)
          end

          it_behaves_like 'returning valid result', 39.65
        end

        context 'when the quantity bought does not exceed the rule units' do
          before do
            basket.add(mask)
            basket.add(pillow)
          end

          it_behaves_like 'returning valid result', 24.4
        end
      end
    end

    context 'with totals promotional rules' do
      let(:basket) { described_class.new([promotional_rule_on_total]) }

      describe 'discount on total by total spent' do
        context 'when the total amount in basket exceeds the argument "spent" '\
          'of the rule' do
          before do
            basket.add(smartbox)
            basket.add(suit_case)
            basket.add(suit_case)
          end

          it_behaves_like 'returning valid result', 86.4
        end

        context 'when the total amount in basket does not exceed the argument '\
          '"spent" of the rule' do
          before do
            basket.add(pillow)
            basket.add(suit_case)
          end

          it_behaves_like 'returning valid result', 58.9
        end
      end
    end

    context 'with product and total promotional rules mixed' do
      let(:basket) do
        described_class.new([promotional_rule_on_mask,
                             promotional_rule_on_total])
      end

      context "when there isn't any matching" do
        before do
          basket.add(mask)
          basket.add(pillow)
          basket.add(smartbox)
        end

        it_behaves_like 'returning valid result', 32.4
      end

      context 'when match the product rule' do
        before do
          basket.add(mask)
          basket.add(mask)
          basket.add(mask)
          basket.add(smartbox)
          basket.add(mask)
        end

        it_behaves_like 'returning valid result', 41
      end

      context 'when match the totals rule' do
        before do
          basket.add(mask)
          basket.add(smartbox)
          basket.add(suit_case)
          basket.add(smartbox)
        end

        it_behaves_like 'returning valid result', 62.55
      end

      context 'when match all the rules' do
        before do
          basket.add(mask)
          basket.add(mask)
          basket.add(mask)
          basket.add(smartbox)
          basket.add(suit_case)
          basket.add(smartbox)
          basket.add(mask)
        end

        it_behaves_like 'returning valid result', 83.7
      end
    end
  end
end
