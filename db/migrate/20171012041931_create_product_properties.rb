class CreateProductProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :product_properties do |t|
      t.string :value
      t.integer :product_id
      t.integer :property_id
      t.integer :position

      t.timestamps
    end
  end
end
