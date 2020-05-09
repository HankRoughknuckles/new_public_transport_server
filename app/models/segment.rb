# typed: strong
class Segment < ApplicationRecord
  belongs_to :tram_line
  belongs_to :station_a, class_name: "Station"
  belongs_to :station_b, class_name: "Station"

  validates_presence_of :tram_line
  validates_presence_of :station_a
  validates_presence_of :station_b
end
