# frozen_string_literal: true

require_relative 'base_rule'

module ShoppingCart
  class PromotionalRule
    # Formula to change the price of a product, depending on the minimum units
    # bought. Arguments used are:
    #  <arguments[:price]#float> New price to apply if <arguments[:units]> is
    #                           greater than quantity
    #  <arguments[:units]#integer> Units to compare with the total units in basket
    #                             of the product
    class DiscountOnItemPriceByUnitsRule < BaseRule
      def total(quantity, price)
        price = arguments[:price] if quantity >= arguments[:units]

        super(quantity, price)
      end
    end
  end
end
