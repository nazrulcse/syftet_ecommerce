class AddFeaturedIdToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :is_featured, :boolean, default: false
  end
end
