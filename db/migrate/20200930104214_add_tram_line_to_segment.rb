class AddTramLineToSegment < ActiveRecord::Migration[6.0]
  def change
    add_reference :segments, :tram_line, null: false, foreign_key: true
  end
end
