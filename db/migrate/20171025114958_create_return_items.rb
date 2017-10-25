class CreateReturnItems < ActiveRecord::Migration[5.1]
  def change
    create_table :return_items do |t|
      t.integer :return_authorization_id
      t.integer :inventory_unit_id
      t.integer :exchange_variant_id
      t.numeric :pre_tax_amount
      t.numeric :included_tax_total
      t.numeric :additional_tax_total
      t.string :reception_status
      t.string :acceptance_status
      t.integer :customer_return_id
      t.integer :reimbursement_id
      t.integer :exchange_inventory_unit_id
      t.text :acceptance_status_errors
      t.integer :preferred_reimbursement_type_id
      t.integer :override_reimbursement_type_id
      t.boolean :resellable

      t.timestamps
    end
  end
end
