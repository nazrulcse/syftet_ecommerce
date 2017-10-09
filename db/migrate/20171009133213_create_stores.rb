class CreateStores < ActiveRecord::Migration[5.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :url
      t.text :meta_description
      t.string :meta_keywords
      t.string :seo_title
      t.string :mail_from_address
      t.string :default_currency
      t.string :code
      t.boolean :default

      t.timestamps
    end
  end
end
