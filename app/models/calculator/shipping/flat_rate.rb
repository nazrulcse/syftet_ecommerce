require_dependency 'shipping_calculator'

module Calculator::Shipping
  class FlatRate < ShippingCalculator
    preference :amount, :decimal, default: 0
    preference :currency, :string, default: -> { Syftet.config.currency }

    def self.description
      I18n.t(:shipping_flat_rate_per_order)
    end

    def compute_package(package)
      self.preferred_amount
    end
  end
end
