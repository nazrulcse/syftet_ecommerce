class CreateCalculators < ActiveRecord::Migration[5.1]
  def change
    create_table :calculators do |t|
      t.string :calculator_type
      t.integer :calculable_id
      t.string :calculable_type
      t.text :preferences
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
