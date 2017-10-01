class CreateAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :assets do |t|
      t.integer :viewable_id
      t.string :viewable_type
      t.integer :attachment_width
      t.integer :attachment_height
      t.integer :attachment_file_size
      t.integer :position
      t.string :attachment_contant
      t.string :attachment_file_name
      t.string :asset_type
      t.datetime :attachment_updated_at
      t.string :alt

      t.timestamps
    end
  end
end
