class CreateInventoryUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :inventory_units do |t|
      t.string :state
      t.integer :variant_id
      t.integer :order_id
      t.integer :shipment_id
      t.boolean :pending
      t.integer :line_item_id

      t.timestamps
    end
  end
end
