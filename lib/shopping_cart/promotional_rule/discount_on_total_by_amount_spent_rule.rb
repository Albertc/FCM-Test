# frozen_string_literal: true

require_relative 'base_rule'

module ShoppingCart
  class PromotionalRule
    # Formula to make a discount of the total amount, depending on the total spent
    # Arguments used are:
    #  <arguments[:spent]#float> Minimum spent to compare with the total spend
    #  <arguments[:discount]#float> % discount to apply over the total
    class DiscountOnTotalByAmountSpentRule < BaseRule
      def total(total_amount)
        return 0 if total_amount <= arguments[:spent]

        (total_amount * arguments[:discount] / 100).round(2)
      end
    end
  end
end
