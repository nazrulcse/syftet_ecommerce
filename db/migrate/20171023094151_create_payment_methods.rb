class CreatePaymentMethods < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_methods do |t|
      t.string :type
      t.string :name
      t.text :description
      t.boolean :active
      t.datetime :deleted_at
      t.string :display_on
      t.boolean :auto_capture
      t.text :preferences
      t.integer :position

      t.timestamps
    end
  end
end
