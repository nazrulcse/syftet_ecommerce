class AddCodeAndTrackingUrlToShippingMethods < ActiveRecord::Migration[5.1]
  def change
    add_column :shipping_methods, :code, :string
    add_column :shipping_methods, :tracking_url, :string
  end
end
