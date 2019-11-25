class AddIndexToSimpleNameOnStations < ActiveRecord::Migration[6.0]
  def change
    add_index :stations, :simple_name
  end
end
