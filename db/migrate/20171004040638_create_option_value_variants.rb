class CreateOptionValueVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :option_value_variants do |t|
      t.integer :variant_id
      t.integer :option_value_id

      t.timestamps
    end
  end
end
