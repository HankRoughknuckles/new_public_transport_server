# typed: strict
module RouteFinder
  module OldTramRouteFinder
    # Represents all the possible paths that can exist between a start_station
    # and an end_station
    class PathsBetweenTwoStations
      extend T::Sig

      sig { returns(Station) }
      attr_accessor :start_station
      sig { returns(Station) }
      attr_accessor :end_station
      sig { returns(T::Array[Path]) }
      attr_accessor :paths

      sig { params(start_station: Station, end_station: Station).void }
      def initialize(start_station, end_station)
        @start_station = start_station
        @end_station = end_station
        @paths = T.let([], T::Array[Path])
      end

      # a shortcut for accessing that paths array that's nested inside this
      # class
      sig { params(index: Integer).returns(T.nilable(Path)) }
      def [](index)
        @paths[index]
      end

      # add a path that connects @start_station to @end_station
      sig { params(path: Path).void }
      def add_path(path)
        @paths << path
      end

      # returns which path out of all of them would take the least amount of
      # time to travel
      sig { returns(T.nilable(Path)) }
      def shortest
        @paths.reduce(@paths.first) do |smallest, path|
          path.travel_time < smallest.travel_time ? path : smallest
        end
      end
    end
  end
end
