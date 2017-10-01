class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.datetime :available_on
      t.datetime :deleted_at
      t.string :slug
      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords
      t.integer :tax_category_id
      t.integer :shipping_category_id
      t.boolean :promotionable
      t.integer :taxon_id
      t.integer :brand_id
      t.boolean :is_master
      t.integer :serial_no
      t.datetime :discontinue_on

      t.timestamps
    end
  end
end
