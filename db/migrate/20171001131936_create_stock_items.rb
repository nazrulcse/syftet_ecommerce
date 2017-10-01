class CreateStockItems < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_items do |t|
      t.integer :stock_location_id
      t.integer :variant_id
      t.integer :count_on_hand
      t.boolean :backorderable
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
