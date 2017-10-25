class CreateRefunds < ActiveRecord::Migration[5.1]
  def change
    create_table :refunds do |t|
      t.integer :payment_id
      t.numeric :amount
      t.string :transaction_id
      t.integer :refund_reason_id
      t.integer :reimbursement_id

      t.timestamps
    end
  end
end
