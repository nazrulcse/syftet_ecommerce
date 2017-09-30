class AddPositionToTaxonomy < ActiveRecord::Migration[5.1]
  def change
    add_column :taxonomies, :position, :integer
  end
end
