class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.numeric :amount
      t.integer :order_id
      t.integer :source_id
      t.string :source_type
      t.integer :payment_method_id
      t.string :state
      t.string :response_code
      t.string :avs_response
      t.string :cvv_response_code
      t.string :cvv_response_message

      t.timestamps
    end
  end
end
