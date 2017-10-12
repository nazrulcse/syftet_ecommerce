class CreateStateChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :state_changes do |t|
      t.string :name
      t.string :previous_state
      t.integer :stateful_id
      t.integer :user_id
      t.string :stateful_type
      t.string :next_state

      t.timestamps
    end
  end
end
