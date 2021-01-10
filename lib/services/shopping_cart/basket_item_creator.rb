# frozen_string_literal: true

require_relative '../../../app/models/product'

module ShoppingCart
  # Search <product> in array <items> and if it doesn't exist, will create it
  # and add to the <items> array
  class BasketItemCreator
    attr_accessor :items, :product

    def initialize(items, product)
      @items = items
      @product = product
    end

    def call
      return unless valid_parameters?

      unless (item = product_in_basket(product))
        item = Basket::BasketItem.new(product)
        items << item
      end

      item
    end

    private

    def product_in_basket(product)
      items.find { |basket_item| basket_item.product.code == product.code }
    end

    def valid_parameters?
      items.is_a?(Array) && product.is_a?(Product)
    end
  end
end
