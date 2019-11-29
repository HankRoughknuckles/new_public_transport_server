class TramLine < ApplicationRecord
  has_many :segment_tram_lines
  has_many :segments, -> { order(:order) }, through: :segment_tram_lines
end
