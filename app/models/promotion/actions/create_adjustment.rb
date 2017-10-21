class Promotion
  module Actions
    class CreateAdjustment < PromotionAction
      include CalculatedAdjustments
      include AdjustmentSource

      before_validation -> { self.calculator ||= Calculator::FlatPercentItemTotal.new }

      def perform(options = {})
        order = options[:order]
        create_unique_adjustment(order, order)
      end

      def compute_amount(order)
        [(order.item_total + order.ship_total), compute(order)].min * -1
      end
    end
  end
end