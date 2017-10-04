class CreateOptionValues < ActiveRecord::Migration[5.1]
  def change
    create_table :option_values do |t|
      t.integer :position
      t.string :name
      t.string :presentation

      t.timestamps
    end
  end
end
