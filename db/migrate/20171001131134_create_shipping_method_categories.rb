class CreateShippingMethodCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_method_categories do |t|
      t.integer :shipping_category_id
      t.integer :shipping_method_id

      t.timestamps
    end
  end
end
