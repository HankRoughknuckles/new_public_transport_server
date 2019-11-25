class Station < ApplicationRecord
  has_many :neighbor_segments, class_name: 'Segment', foreign_key: 'station_a_id'
  has_many :neighbors, through: :neighbor_segments, source: 'station_b'

  def add_neighbor(neighbor, travel_time)
    Segment.create(station_a: self, station_b: neighbor, travel_time: travel_time)
    Segment.create(station_a: neighbor, station_b: self, travel_time: travel_time)
  end
end
