class CreateSegmentTramLines < ActiveRecord::Migration[6.0]
  def change
    create_table :segment_tram_lines do |t|
      t.references :segment, null: false, foreign_key: true
      t.references :tram_line, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
