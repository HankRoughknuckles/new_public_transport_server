# frozen_string_literal: true

# typed: strict
module RouteFinder
  module OldTramRouteFinder
    # For managing what stations a given start_station is capable of reaching,
    # and what paths one would take in order to get to those destinations.
    class PathsFromStation
      extend T::Sig
      sig { returns T::Hash[Integer, PathsBetweenTwoStations] }
      attr_reader :paths

      sig { params(start_station: Station).void }
      def initialize(start_station)
        @start_station = start_station

        # @paths - values are arrays containing all paths going from
        # start_station to that destination, keyed by the destination station's
        # id
        @paths = T.let(
          {}, T::Hash[Integer, PathsBetweenTwoStations]
        )
        @paths = Station.all.each_with_object({}) do |station, acc|
          acc[station.id] = PathsBetweenTwoStations.new(@start_station, station)
        end

        # add the stations that are immediately next to start_station
        @start_station.outgoing_segments.each do |segment|
          @paths[segment.station_b.id].add_path(Path.new([segment]))
        end
      end

      # Add a path to the @paths list from the start_station to the passed
      # destination
      sig { params(destination: Station, path: Path).void }
      def add_path(destination, path)
        all_paths_to(destination)&.add_path(path)
      end

      # Returns an object representing all the paths that exist between
      # @start_station and the passed destination
      sig { params(destination: Station).returns T.nilable(PathsBetweenTwoStations) }
      def all_paths_to(destination)
        @paths[destination.id]
      end

      # Returns the path that has the shortest travel time between
      # @start_station and the passed destination
      sig { params(destination: Station).returns T.nilable(Path) }
      def shortest_to(destination)
        all_paths_to(destination)&.shortest
      end

      # Get the shortest path to each station that start_station is capable of
      # reaching.  Keyed by the destination station's id
      sig { returns(T::Hash[Integer, T.nilable(Path)]) }
      def shortest_paths
        @paths.transform_values(&:shortest)
      end
    end
  end
end
