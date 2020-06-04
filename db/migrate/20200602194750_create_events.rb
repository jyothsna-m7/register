class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.references :user, null: false
      t.datetime :clock_in, null: false
      t.datetime :clock_out

      t.timestamps
    end

    add_index :events, [:user_id, :clock_in, :clock_out], name: 'event_round_time'
  end
end
