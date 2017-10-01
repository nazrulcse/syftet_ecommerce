class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices do |t|
      t.integer :variant_id
      t.float :amount
      t.string :currency
      t.datetime :deleted_at
      t.float :agent_price

      t.timestamps
    end
  end
end
