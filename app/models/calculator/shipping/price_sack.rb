require_dependency 'shipping_calculator'

module Calculator::Shipping
  class PriceSack < ShippingCalculator
    preference :minimal_amount, :decimal, default: 0
    preference :normal_amount, :decimal, default: 0
    preference :discount_amount, :decimal, default: 0
    preference :currency, :string, default: -> { Syftet.config.currency }

    def self.description
      I18n.t(:shipping_price_sack)
    end

    def compute_package(package)
      compute_from_price(total(package.contents))
    end

    def compute_from_price(price)
      if price < self.preferred_minimal_amount
        self.preferred_normal_amount
      else
        self.preferred_discount_amount
      end
    end
  end
end
