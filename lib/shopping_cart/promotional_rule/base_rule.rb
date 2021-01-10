# frozen_string_literal: true

module ShoppingCart
  class PromotionalRule
    # Parent of all the formula rules,
    # its calculation is used for product rules and doesn't have any discount.
    # its calculation is price * quantity
    # Mandatory parameters for method #total
    #  <quantity#integer> total units in basket
    #  <price#float> price to apply
    class BaseRule
      attr_reader :arguments

      def initialize(**arguments)
        @arguments = arguments
      end

      def total(quantity, price)
        (quantity * price).round(2)
      end
    end
  end
end
