class CreateStockLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_locations do |t|
      t.string :name
      t.boolean :default
      t.string :address1
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.string :phone
      t.boolean :active
      t.boolean :backorderable_default
      t.boolean :propagate_all_variants
      t.string :admin_name

      t.timestamps
    end
  end
end
