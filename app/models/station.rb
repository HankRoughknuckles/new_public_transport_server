# typed: strict
require 'sorbet-runtime'

class Station < ApplicationRecord
  extend T::Sig

  has_many :neighbor_segments, class_name: 'Segment', foreign_key: 'station_a_id'

  before_save :convert_name_to_simple_name

  validates :name, uniqueness: true
  validates :simple_name, uniqueness: true

  sig { returns T::Array[Station] }
  def neighbors
    self.outgoing_segments.map { |segment| segment.station_b }.uniq
  end

  sig { void }
  def convert_name_to_simple_name
    self.simple_name = I18n.transliterate(self.name)
  end

  sig { params({neighbor: Station, tram_line: TramLine, travel_time: T.nilable(Integer)}).void }
  def add_neighbor(neighbor, tram_line, travel_time = 2)
    Segment.find_or_create_by(station_a: self, station_b: neighbor, travel_time: travel_time, tram_line: tram_line)
    Segment.find_or_create_by(station_a: neighbor, station_b: self, travel_time: travel_time, tram_line: tram_line)
  end

  # TODO: add tests
  # sig { returns Segment::ActiveRecord_Relation }
  def outgoing_segments
    Segment.where({station_a_id: self.id})
  end
end
