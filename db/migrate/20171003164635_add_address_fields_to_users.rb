class AddAddressFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :ship_address_id, :integer
    add_column :users, :bill_address_id, :integer
    add_column :users, :user_type, :string
  end
end
