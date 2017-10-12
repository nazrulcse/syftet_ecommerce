module Stock
  class InventoryUnitBuilder
    def initialize(order)
      @order = order
    end

    def units
      @order.line_items.flat_map do |line_item|
        line_item.quantity.times.map do |i|
          @order.inventory_units.build(
              pending: true,
              variant_id: line_item.variant.id,
              line_item_id: line_item.id,
              order_id: @order.id,
              state: 'on_hand'
          )
        end
      end
    end
  end
end
