class CreateContactUs < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_us do |t|
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :order_number
      t.string :inquiry_type
      t.text :message

      t.timestamps
    end
  end
end
