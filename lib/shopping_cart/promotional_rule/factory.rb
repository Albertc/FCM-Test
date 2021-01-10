# frozen_string_literal: true

module ShoppingCart
  class PromotionalRule
    # Factory to choose the PromotionalRule subclass according the promotional
    # rules passed on the Basket initialization
    class Factory
      def self.for(promotion_rule_name, **arguments)
        case promotion_rule_name
        when :discount_on_total_by_amount_spent
          PromotionalRule::DiscountOnTotalByAmountSpentRule.new arguments
        when :discount_on_item_price_by_units
          PromotionalRule::DiscountOnItemPriceByUnitsRule.new arguments
        when nil
          PromotionalRule::BaseRule.new arguments
        else
          raise "Promotional rule #{promotion_rule_name} not configured"
        end
      end
    end
  end
end
