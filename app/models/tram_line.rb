# frozen_string_literal: true

# typed: strict
require 'sorbet-runtime'

# Model representing one direction in a tram line.  For instance, line 1 has two
# different directions, one starting at Sidliste Petriny and the other starting
# at Spojovaci.  So as a result, Line 1 would actually consist of two of these
# TramLine objects.  One for each direction.
#
# Each TramLine has an outgoing boolean associated with it.  This is for
# determining which direction of the tram line it is (outgoing is assigned
# arbitrarily as true or false.  The only requirement is that both direction
# tram lines have opposite values
class TramLine < ApplicationRecord
  extend T::Sig
  has_many :segments

  sig do
    params(name: String, outgoing: T::Boolean, station_names: T::Array[String])
      .returns(TramLine)
  end
  def self.from_station_names(name, outgoing, station_names = [])
    tram_line = TramLine.create(name: name, outgoing: outgoing)
    station_names.each_with_index do |station_name, index|
      station = Station.find_or_create_by(name: station_name)

      # make a segment going from this station to the next one
      if index < station_names.length - 1
        next_station = Station.find_or_create_by(name: station_names[index + 1])
        station.add_segment_going_to(next_station, tram_line)
      end
    end

    tram_line
  end
end
