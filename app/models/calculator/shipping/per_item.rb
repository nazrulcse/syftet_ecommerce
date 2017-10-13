require_dependency 'shipping_calculator'

module Calculator::Shipping
  class PerItem < ShippingCalculator
    preference :amount, :decimal, default: 0
    preference :currency, :string, default: -> { Syftet.config.currency }

    def self.description
      I18n.t(:shipping_flat_rate_per_item)
    end

    def compute_package(package)
      compute_from_quantity(package.contents.sum(&:quantity))
    end

    def compute_from_quantity(quantity)
      self.preferred_amount * quantity
    end
  end
end
