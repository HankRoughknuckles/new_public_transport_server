class CreateSegments < ActiveRecord::Migration[6.0]
  def change
    create_table :segments do |t|
      t.integer :station_a_id, null: false
      t.integer :station_b_id, null: false
      t.integer :travel_time

      t.timestamps
    end
  end
end
