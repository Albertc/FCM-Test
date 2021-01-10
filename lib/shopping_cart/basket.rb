# frozen_string_literal: true

require_relative '../../app/models/product.rb'

module ShoppingCart
  # Base class for the checkout system, it's initilized with the promotional rules
  # Public methods
  #  add: Add new items received by parameters, each one is a instance of Product
  #  total: calculate and returns the total amount
  class Basket
    def initialize(promotional_rules = [])
      @promotional_rules = promotional_rules
      @items = []
    end

    def add(product)
      return unless product.is_a?(Product)

      item = find_or_create_item_in_basket(product)

      item.quantity += 1
    end

    def total
      total_products = total_items_with_promos + total_items_without_promos

      total_products_less_discount_promos(total_products)
    end

    private

    attr_accessor :items
    attr_reader :promotional_rules

    def total_items_with_promos
      sum_items_amounts(items_with_promotional_rules)
    end

    def total_items_without_promos
      sum_items_amounts(items_without_promotional_rules)
    end

    def total_products_less_discount_promos(total_products)
      promotional_rules_without_products.inject(total_products) do |total, promo|
        discount = pricing_formula_for(promo).total(total)

        total - discount
      end
    end

    def items_with_promotional_rules
      items.select { |item| promotional_rule_for_item(item) }
    end

    def items_without_promotional_rules
      items.reject { |item| promotional_rule_for_item(item) }
    end

    def promotional_rules_without_products
      promotional_rules.reject { |promo| promo.arguments[:product] }
    end

    def find_or_create_item_in_basket(product)
      BasketItemCreator.new(items, product).call
    end

    def sum_items_amounts(items)
      items.inject(0) { |sum, item| sum + price_for(item) }
    end

    def price_for(item)
      promotional_rule = promotional_rule_for_item(item)
      quantity = item.quantity
      price = item.product.price

      pricing_formula_for(promotional_rule).total(quantity, price)
    end

    def pricing_formula_for(promotional_rule)
      promotional_name = promotional_rule&.name
      arguments = promotional_rule&.arguments || {}

      PromotionalRule::Factory.for(promotional_name, arguments)
    end

    # Search into promotional_rules a rule of a given product
    def promotional_rule_for_item(item)
      promotional_rules.find do |promo|
        promo.arguments[:product] == item.product
      end
    end
  end
end
