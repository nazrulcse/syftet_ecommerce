class AddDefaultValueToCountOnHandToStockItems < ActiveRecord::Migration[5.1]
  def change
    change_column :stock_items, :count_on_hand, :integer, default: 0
  end
end
