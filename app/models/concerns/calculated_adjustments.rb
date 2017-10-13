module CalculatedAdjustments
  extend ActiveSupport::Concern

  included do
    has_one :calculator, class_name: "Calculator", as: :calculable, inverse_of: :calculable, dependent: :destroy, autosave: true
    accepts_nested_attributes_for :calculator
    validates :calculator, presence: true
    delegate :compute, to: :calculator

    def self.calculators
      spree_calculators.send model_name_without_spree_namespace
    end

    def calculator_type
      calculator.class.to_s if calculator #TODO: Had to overwrite
      # calculator.calculator_type if calculator
    end

    def calculator_type=(calculator_type)
      klass = calculator_type.constantize if calculator_type
      self.calculator = klass.new(calculator_type: calculator_type) if klass && !self.calculator.is_a?(klass)
    end

    private
    def self.model_name_without_spree_namespace
      self.to_s.tableize.gsub('/', '_').sub('spree_', '')
    end

    def self.spree_calculators
      # Rails.application.config.spree.calculators
      {
          shipping_methods: [
              Calculator::Shipping::FlatPercentItemTotal,
              Calculator::Shipping::FlatRate,
              Calculator::Shipping::FlexiRate,
              Calculator::Shipping::PerItem,
              Calculator::Shipping::PriceSack
          ],
          tax_rates: [Calculator::DefaultTax]
      }
    end
  end
end