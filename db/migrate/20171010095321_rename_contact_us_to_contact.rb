class RenameContactUsToContact < ActiveRecord::Migration[5.1]
  def change
    rename_table :contact_us, :contacts
  end
end
