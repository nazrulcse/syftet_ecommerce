require_dependency 'shipping_calculator'

module Calculator::Shipping
  class FlatPercentItemTotal < ShippingCalculator
    # include Preferences::PreferableClassMethods
    preference :flat_percent, :decimal, default: 0

    def self.description
      I18n.t(:flat_percent)
    end

    def compute_package(package)
      compute_from_price(total(package.contents))
    end

    def compute_from_price(price)
      value = price * BigDecimal(self.preferred_flat_percent.to_s) / 100.0
      (value * 100).round.to_f / 100
    end
  end
end