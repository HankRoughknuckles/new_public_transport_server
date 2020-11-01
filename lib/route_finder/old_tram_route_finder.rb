# typed: strict
require 'station'
require_relative 'old_tram_route_finder/path'
require_relative 'old_tram_route_finder/paths_between_two_stations'
require_relative 'old_tram_route_finder/paths_from_station'

module RouteFinder
  module OldTramRouteFinder
    extend T::Sig

    sig { params(start_station: Station, end_station: Station).returns(T.nilable(Path)) }
    def shortest_path(start_station, end_station)
      all_paths_from_station(start_station).shortest_to(end_station)
    end

    sig { params(start_station: Station).returns(PathsFromStation) }
    def all_paths_from_station(start_station)
      paths_from_start = PathsFromStation.new(start_station)

      # start by checking the segments going out from the start
      paths_to_check = start_station.outgoing_segments.map do |segment|
        Path.new([segment])
      end

      paths_to_check.each do |path|
        final_station = T.must(path.final_station)
        next_segments = final_station.outgoing_segments

        # for each segment attached to the next station
        #   - if each outgoing segment from there doesn't loop back into our path
        #     - add it to the list of possible paths (from start_station to that)
        #     - check every path going out from there
        next_segments.each do |next_segment|
          next_station = next_segment.station_b

          if !path.include?(next_station)
            new_path = Path.new(path.segments + [next_segment])
            paths_from_start.add_path(next_station, new_path)
            paths_to_check << new_path
          end
        end
      end

      return paths_from_start
    end
  end
end
