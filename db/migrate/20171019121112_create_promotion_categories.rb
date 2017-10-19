class CreatePromotionCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :promotion_categories do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
