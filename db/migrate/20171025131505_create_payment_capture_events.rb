class CreatePaymentCaptureEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_capture_events do |t|
      t.numeric :amount
      t.integer :payment_id

      t.timestamps
    end
  end
end
