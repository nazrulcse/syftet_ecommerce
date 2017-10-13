class CreatePromotionActions < ActiveRecord::Migration[5.1]
  def change
    create_table :promotion_actions do |t|
      t.integer :promotion_id
      t.integer :position
      t.string :type
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
