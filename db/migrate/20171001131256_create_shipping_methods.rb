class CreateShippingMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_methods do |t|
      t.string :name
      t.string :display_on
      t.datetime :deleted_at
      t.string :admin_name

      t.timestamps
    end
  end
end
