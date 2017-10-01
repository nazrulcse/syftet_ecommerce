class CreateProductTaxons < ActiveRecord::Migration[5.1]
  def change
    create_table :products_taxons do |t|
      t.integer :product_id
      t.integer :taxon_id
      t.integer :position

      t.timestamps
    end
  end
end
