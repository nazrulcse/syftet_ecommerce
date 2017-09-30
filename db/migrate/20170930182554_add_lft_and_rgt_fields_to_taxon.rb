class AddLftAndRgtFieldsToTaxon < ActiveRecord::Migration[5.1]
  def change
    add_column :taxons, :lft, :integer
    add_column :taxons, :rgt, :integer
  end
end
