class AddTrackInventoryFieldToVariants < ActiveRecord::Migration[5.1]
  def change
    add_column :variants, :track_inventory, :boolean, :default => true
  end
end
