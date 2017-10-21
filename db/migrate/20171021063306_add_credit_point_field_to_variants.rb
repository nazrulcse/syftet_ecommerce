class AddCreditPointFieldToVariants < ActiveRecord::Migration[5.1]
  def change
    add_column :variants, :credit_point, :float, default: 0
  end
end
