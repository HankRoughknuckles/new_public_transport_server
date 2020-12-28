# frozen_string_literal: true

# typed: strong

# Model representing the piece that connects each Station to its neighbor.  Each
# segment represents a one-directional movement: If two stations are connected
# via a segment, that means that a tram at station_a will use this segment to
# travel to station_b.
#
# This is for representing a bit of track that a tram line uses to travel.  As
# such, a tram line is just composed of an ordered list of segments, connecting
# each station
class Segment < ApplicationRecord
  belongs_to :tram_line
  belongs_to :station_a, class_name: 'Station'
  belongs_to :station_b, class_name: 'Station'

  validates_presence_of :tram_line
  validates_presence_of :station_a
  validates_presence_of :station_b
end
