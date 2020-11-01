# typed: true
class CreateTramLines < ActiveRecord::Migration[6.0]
  def change
    create_table :tram_lines do |t|
      t.string :name
      t.boolean :outgoing # whether the tram is outgoing or incoming

      t.timestamps
    end
  end
end
