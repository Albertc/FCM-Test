# frozen_string_literal: true

module ShoppingCart
  # Class to define which rules will apply the Basket to calculate the amounts.
  # Init parameters:
  #  <name#symbol> name of the rule
  #  <arguments#hash> arguments needed according the rule, such as :units or :price
  class PromotionalRule
    attr_reader :name, :arguments

    def initialize(name, **arguments)
      @name = name
      @arguments = arguments
    end
  end
end
