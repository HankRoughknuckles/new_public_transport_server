# typed: strong
class Segment < ApplicationRecord
  belongs_to :tram_line
  belongs_to :station_a, class_name: "Station"
  belongs_to :station_b, class_name: "Station"
end
