class CreateTramLines < ActiveRecord::Migration[6.0]
  def change
    create_table :tram_lines do |t|
      t.string :name

      t.timestamps
    end
  end
end
