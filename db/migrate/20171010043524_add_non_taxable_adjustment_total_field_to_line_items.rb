class AddNonTaxableAdjustmentTotalFieldToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :non_taxable_adjustment_total, :numeric, default: 0
    add_column :line_items, :taxable_adjustment_total, :numeric, default: 0
  end
end
