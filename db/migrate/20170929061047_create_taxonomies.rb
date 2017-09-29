class CreateTaxonomies < ActiveRecord::Migration[5.1]
  def change
    create_table :taxonomies do |t|
      t.string :name
      t.string :meta_title
      t.string :meta_key
      t.string :meta_description
      t.string :slug
      t.string :name
      t.timestamps
    end
  end
end
