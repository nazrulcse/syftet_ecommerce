class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :provider, :string, default: 'email', null: false
    add_column :users, :uid, :string, default: '', null: false
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :tokens, :text

    add_index :users, [:uid, :provider]
  end
end
