class CreateAdjustments < ActiveRecord::Migration[5.1]
  def change
    create_table :adjustments do |t|
      t.integer :source_id
      t.string :source_type
      t.integer :adjustable_id
      t.string :adjustable_type
      t.numeric :amount, default: 0
      t.string :label
      t.boolean :mandatory
      t.boolean :eligible
      t.string :state
      t.integer :order_id
      t.boolean :included

      t.timestamps
    end
  end
end
