class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.string :type
      t.text :message
      t.string :delivery_report
      t.string :product_price
      t.text :others
      t.integer :rate

      t.timestamps
    end
  end
end
