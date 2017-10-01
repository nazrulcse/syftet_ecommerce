class CreateVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :variants do |t|
      t.string :sku
      t.decimal :weight
      t.decimal :width
      t.decimal :height
      t.decimal :depth
      t.datetime :deleted_at
      t.boolean :is_master
      t.integer :product_id
      t.decimal :cost_price
      t.integer :position
      t.string :cost_currency
      t.integer :stock_items_count
      t.datetime :discontinue_on
      t.string :color
      t.string :color_image

      t.timestamps
    end
  end
end
