class AddSizeFieldsToVariants < ActiveRecord::Migration[5.1]
  def change
    add_column :variants, :size, :string
  end
end
