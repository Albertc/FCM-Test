# frozen_string_literal: true

module ShoppingCart
  class Basket
    # Item of a basket, it consists of a product and a quantity.
    # Object generated and added to the array "items" of the basket each time
    # Basket#add(product) is called
    class BasketItem
      attr_accessor :quantity
      attr_reader :product

      def initialize(product)
        @product = product
        @quantity = 0
      end
    end
  end
end
