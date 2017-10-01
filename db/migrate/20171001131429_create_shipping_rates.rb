class CreateShippingRates < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_rates do |t|
      t.integer :shipment_id
      t.integer :shipping_method_id
      t.boolean :selected
      t.float :cost

      t.timestamps
    end
  end
end
