class CreatePromotions < ActiveRecord::Migration[5.1]
  def change
    create_table :promotions do |t|
      t.string :description
      t.datetime :expires_at
      t.datetime :starts_at
      t.string :name
      t.string :promotion_type
      t.integer :usage_limit
      t.string :match_policy
      t.string :code
      t.boolean :advertise
      t.string :path
      t.integer :promotion_category_id

      t.timestamps
    end
  end
end
