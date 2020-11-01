module RouteFinder
  module OldTramRouteFinder
    # TODO: tests
    # Represents all the possible paths that can exist between a start_station
    # and an end_station
    class PathsBetweenTwoStations
      extend T::Sig

      attr_accessor :start_station, :end_station, :paths

      sig { params(start_station: Station, end_station: Station).void }
      def initialize(start_station, end_station)
        @start_station = start_station
        @end_station = end_station
        @paths = T.let([], T::Array[Path])
      end

      # a shortcut for accessing that paths array that's nested inside this
      # class
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
        # TODO: test what happens when @paths is empty
        @paths.reduce(@paths.first) do |smallest, path|
          path.travel_time < smallest.travel_time ? path : smallest
        end
      end
    end
  end
end
