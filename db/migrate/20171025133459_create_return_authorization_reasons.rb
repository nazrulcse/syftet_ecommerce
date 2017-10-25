class CreateReturnAuthorizationReasons < ActiveRecord::Migration[5.1]
  def change
    create_table :return_authorization_reasons do |t|
      t.string :name
      t.boolean :active
      t.boolean :mutable

      t.timestamps
    end
  end
end
