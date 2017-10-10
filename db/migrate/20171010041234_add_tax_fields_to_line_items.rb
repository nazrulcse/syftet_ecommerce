class AddTaxFieldsToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :included_tax_total, :numeric, default: 0
    add_column :line_items, :additional_tax_total, :numeric, default: 0
  end
end
