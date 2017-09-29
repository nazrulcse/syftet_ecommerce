class CreateTaxons < ActiveRecord::Migration[5.1]
  def change
    create_table :taxons do |t|
      t.integer :parent_id
      t.string :name
      t.string :permalink
      t.integer :taxonomy_id
      t.string :description
      t.string :meta_title
      t.string :meta_keywords
      t.string :meta_description
      t.timestamps
    end
  end
end
