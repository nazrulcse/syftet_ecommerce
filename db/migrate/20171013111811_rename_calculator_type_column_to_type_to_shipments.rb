class RenameCalculatorTypeColumnToTypeToShipments < ActiveRecord::Migration[5.1]
  def change
    rename_column :calculators, :calculator_type, :type
  end
end
