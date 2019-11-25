class CreateStations < ActiveRecord::Migration[6.0]
  def change
    create_table :stations do |t|
      t.string :name
      t.string :simple_name

      t.timestamps
    end
  end
end
