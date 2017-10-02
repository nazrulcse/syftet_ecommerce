class AddApiKeyFieldToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :syftet_api_key, :string
  end
end
