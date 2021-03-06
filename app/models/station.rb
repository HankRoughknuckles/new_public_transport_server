class Station < ApplicationRecord
  has_many :neighbor_segments, class_name: 'Segment', foreign_key: 'station_a_id'
  has_many :neighbors, through: :neighbor_segments, source: 'station_b'

  before_save :convert_name_to_simple_name

  validates :name, uniqueness: :true
  validates :simple_name, uniqueness: :true

  def convert_name_to_simple_name
    self.simple_name = I18n.transliterate(self.name)
  end

  def add_neighbor(neighbor, travel_time = 2)
    Segment.find_or_create_by(station_a: self, station_b: neighbor, travel_time: travel_time)
    Segment.find_or_create_by(station_a: neighbor, station_b: self, travel_time: travel_time)
  end
end
