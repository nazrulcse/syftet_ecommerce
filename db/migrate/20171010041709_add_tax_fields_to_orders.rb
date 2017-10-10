class AddTaxFieldsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :included_tax_total, :numeric, default: 0
    add_column :orders, :additional_tax_total, :numeric, default: 0
  end
end
