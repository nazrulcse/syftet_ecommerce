class AddLftAndRgtFieldsToTaxon < ActiveRecord::Migration[5.1]
  def change
    add_column :taxons, :lft, :integer, default: 0
    add_column :taxons, :rgt, :integer, default: 0
  end
end
