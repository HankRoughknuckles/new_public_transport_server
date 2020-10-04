module RouteFinder
  module OldTrams
    # TODO: dockblock
    # TODO: tests
    class PathsBetweenTwoStations
      extend T::Sig

      attr_accessor :start_station, :end_station, :paths

      sig { params(start_station: Station, end_station: Station).void }
      def initialize(start_station, end_station)
        @start_station = start_station
        @end_station = end_station
        @paths = T.let([], T::Array[Path])
      end

      sig { params(path: Path).void }
      def add_path(path)
        @paths << path
      end

      sig { returns(T.nilable(RouteFinder::OldTrams::Path)) }
      def shortest
        @paths.reduce(@paths.first) do |smallest, path|
          path.travel_time < smallest.travel_time ? path : smallest
        end
      end
    end
  end
end
