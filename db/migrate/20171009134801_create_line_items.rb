class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :line_items do |t|
      t.integer :variant_id
      t.integer :order_id
      t.integer :quantity
      t.float :price
      t.float :cost_price
      t.string :currency
      t.numeric :adjustment_total
      t.numeric :promo_total
      t.string :size

      t.timestamps
    end
  end
end
