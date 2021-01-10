# frozen_string_literal: true

# This is a FAKE product class to simulate/mock a Product model in a Rails app
class Product
  attr_reader :code, :name, :price

  def initialize(**attributes)
    @code = attributes[:code]
    @name = attributes[:name]
    @price = attributes[:price]
  end
end
