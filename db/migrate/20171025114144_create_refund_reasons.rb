class CreateRefundReasons < ActiveRecord::Migration[5.1]
  def change
    create_table :refund_reasons do |t|
      t.string :name
      t.boolean :active
      t.boolean :mutable

      t.timestamps
    end
  end
end
