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

  # make a segment from this station to the passed one (on the passed tram
  # line), and also make another segment going in the opposite direction (also
  # on the same tram line). Note - this should not be used in production, this
  # is mostly for setting up test data.  In real life, there will be a separate
  # TramLine for each direction
  sig { params({neighbor: Station, tram_line: TramLine, travel_time: T.nilable(Integer)}).void }
  def add_two_way_connection_with(neighbor, tram_line, travel_time = 2)
    self.add_segment_going_to(neighbor, tram_line, travel_time)
    neighbor.add_segment_going_to(self, tram_line, travel_time)
  end

  # make a one way connection with the passed neighbor, marking this station as
  # the start and the neighbor as the destination
  sig { params({neighbor: Station, tram_line: TramLine, travel_time: T.nilable(Integer)}).void }
  def add_segment_going_to(neighbor, tram_line, travel_time = 2)
    Segment.find_or_create_by(station_a: self, station_b: neighbor, travel_time: travel_time, tram_line: tram_line)
  end

  sig { returns T::Array[Segment] }
  def outgoing_segments
    Segment.where({station_a_id: self.id}).to_a
  end
end
