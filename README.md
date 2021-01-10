# FCM Dev test - Implementation of a checkout system with promotional discounts

## Test Requirements

Our provider is a company selling products for travelers, here is a sample of some of the products available on our site:


|Product code  | Name          | Price |
|--------------|---------------|-------|
|001           | FPP3 mask     | 9.50€ |
|002           | suit case     | 44.00€|
|003           | travel pillow | 14.90€|


Our marketing team wants to offer promotions as an incentive for our customers to purchase these items.
If you spend over 60€, then you get 10% off of your purchase. If you buy 2 or more FPP3 mask then the price drops to 8.25€
Our check-out can scan items in any order, and because our promotions will change, it needs to be flexible regarding our promotional rules.
The interface to our checkout looks like this (shown in Ruby):

```ruby
basket = Basket.new(promotional_rules)
basket.add(item)
basket.add(item)
price = basket.total
```

Implement a Basket system that fulfills these requirements. You can use any version of Ruby on Rails that you want, you could even not use ruby at all.

Sample data

```
Basket: 001,002,003
Total expected: 61.56€

Basket: 001,003,001
Total expected: 31.40€

Basket: 001,002,001,003
Total expected: 67.77€
```

## Technical Requirements

- Ruby 2.5.8

## How to use

First of all we need to create an array with all the promotional rules we want to use.
Each promotional rule is created through `PromotionalRule` class, each rule has a name, for now we have `discount_on_total_by_amount_spent` and `discount_on_item_price_by_units`.
Also, needs another parameter that is a `hash` to indicate the arguments needed for each rule, these are what we have for now:

| Name                              | Description                        | Arguments     |
|-----------------------------------|------------------------------------|---------------|
|`discount_on_total_by_amount_spent`|When user spends N €, gets a Y % off, from the total spent|`spent` `discount`|
|`discount_on_item_price_by_units`  |When user buys N or more products, the price of that product drops to Y €|`units` `price` `product`|

Heach promotional rule needs a class subclass of `::ShoppingCart::PromotionalRule` child of `BaseRule`, like `ShoppingCart::PromotionalRule::NewClassRule < BaseRule`

This class is in charge of the calculation, to do so needs a method `total` with the parameters `quantity` and `price`:
- If it's regarding a rule for a product (we will pass a `:product` key in the hash of parametes) will receive the quantity of that product in the basket and its price. Calling `super(quantity, price)` we get the quantity * price result.
- It it's regarding a rule that doesn't depend of a product, `quantity` will receive the total units in the Basket, and `price` the total amount to pay. Here we do not call to `super`

At the end we need to inform to the factory which decides which class use according the promotional rule name, in `ShoppingCart::PromotionalRule::Factory`

The interface of the promotional rules setup must be something like:

```Ruby
promotional_rules = []
promotional_rules << PromotionalRule.new(:discount_on_total_by_amount_spent,
                                         spent: 60
                                         discount: 10)

promotional_rules << PromotionalRule.new(:discount_on_item_price_by_units,
                                         units: 2
                                         price: 8.5,
                                         product: <Product>)
```

This `promotional_rules` array is the paremeter we pass to the init of our checkout system, thurough the class `Basket`:

```Ruby
basket = Basket.new(promotional_rules)
basket.add(item)
basket.add(item)
price = basket.total
```
Each `item` passed to the method `add` is a product, For this test we can create a product like:

```Ruby
Product.new(code: '001', name: 'FPP3 mask', price: 9.5)
```

So, all together could be something like:

```Ruby
Dir["app/**/*.rb"].each { |file| require_relative file }
Dir["lib/**/*.rb"].each { |file| require_relative file }

mask = Product.new(code: '001', name: 'FPP3 mask', price: 9.5)
suit_case = Product.new(code: '002', name: 'suit case ', price: 44.0)
pillow = Product.new(code: '003', name: 'travel pillow', price: 14.9)

promotional_rules = []
promotional_rules <<
    ShoppingCart::PromotionalRule.new(:discount_on_total_by_amount_spent,
                                    spent: 60,
                                    discount: 10)

promotional_rules <<
    ShoppingCart::PromotionalRule.new(:discount_on_item_price_by_units,
                                    units: 2,
                                    price: 8.25,
                                    product: mask)

basket = ShoppingCart::Basket.new(promotional_rules)

basket.add(mask)
basket.add(suit_case)
basket.add(mask)
basket.add(pillow)

puts basket.total # => 67.86
```

## Testing

Execute `bundle exec rspec` within the project folder, and the output result should be:

```
Finished in 0.01269 seconds (files took 0.08745 seconds to load)
36 examples, 0 failures

```
