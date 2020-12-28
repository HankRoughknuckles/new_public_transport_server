# typed: strict
require 'sorbet-runtime'

class TramLine < ApplicationRecord
  extend T::Sig
  has_many :segments

  sig {
    params(name: String, outgoing: T::Boolean, station_names: T::Array[String])
      .returns(TramLine)
  }
  def self.from_station_names(name, outgoing, station_names = [])
    tram_line = TramLine.create(name: name, outgoing: outgoing)
    station_names.each_with_index do |station_name, index|
      station = Station.find_or_create_by(name: station_name)
      if index > 0
        previous_station = Station.find_or_create_by(name: station_names[index - 1])
        station.add_two_way_connection_with(previous_station, tram_line)
      end
    end

    return tram_line
  end
end
