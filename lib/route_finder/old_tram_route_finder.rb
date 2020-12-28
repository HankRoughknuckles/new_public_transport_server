# frozen_string_literal: true

# typed: strict
require 'station'
require_relative 'old_tram_route_finder/path'
require_relative 'old_tram_route_finder/paths_between_two_stations'
require_relative 'old_tram_route_finder/paths_from_station'

module RouteFinder
  # This module contains the methods necessary for finding paths between one
  # station and another using the "old" tram system - i.e. - the system where
  # there are tram lines and the trams only go on one line.  In order to change
  # lines, a passenger would have to get off the tram and wait for another one.
  # We just estimate that delay, instead of actually dynamically calculating it
  module OldTramRouteFinder
    extend T::Sig

    sig { params(start_station: Station, end_station: Station).returns(T.nilable(Path)) }
    def self.shortest_path(start_station, end_station)
      all_paths_from_station(start_station).shortest_to(end_station)
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    sig { params(start_station: Station).returns(PathsFromStation) }
    def self.all_paths_from_station(start_station)
      paths_from_start = PathsFromStation.new(start_station)

      # start by checking the segments going out from the start
      paths_to_check = start_station.outgoing_segments.map { |s| Path.new([s]) }

      paths_to_check.each do |path|
        final_station = T.must(path.final_station)
        next_segments = final_station.outgoing_segments

        # for each segment attached to the next station
        #   - if each outgoing segment from there doesn't loop back into our path
        #     - add it to the list of possible paths (from start_station to that)
        #     - check every path going out from there
        next_segments.each do |next_segment|
          next_station = next_segment.station_b

          next if path.include?(next_station)

          new_path = Path.new(path.segments + [next_segment])
          paths_from_start.add_path(next_station, new_path)
          paths_to_check << new_path
        end
      end

      paths_from_start
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
  end
end
