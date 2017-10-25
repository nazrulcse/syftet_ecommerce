class CreateReturnAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :return_authorizations do |t|
      t.string :number
      t.string :state
      t.integer :order_id
      t.text :memo
      t.integer :stock_location_id
      t.integer :return_authorization_reason_id

      t.timestamps
    end
  end
end
