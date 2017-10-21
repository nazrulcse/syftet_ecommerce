class AddMorePriceFieldsToPrices < ActiveRecord::Migration[5.1]
  def change
    add_column :prices, :original_price, :numeric
  end
end
