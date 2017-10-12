class RenameStateLocVersionFieldToStateLockVersionToOrders < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :state_loc_version, :state_lock_version
  end
end
