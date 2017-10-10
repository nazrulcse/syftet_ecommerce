class CreateOrderPromotions < ActiveRecord::Migration[5.1]
  def change
    create_table :order_promotions do |t|
      t.integer :order_id
      t.integer :promotion_id

      t.timestamps
    end
  end
end
