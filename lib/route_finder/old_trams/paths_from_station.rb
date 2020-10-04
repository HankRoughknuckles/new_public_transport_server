# typed: strict
module RouteFinder
  module OldTrams
    # TODO: tests
    class PathsFromStation
      extend T::Sig

      sig { params(start_station: Station).void }
      def initialize(start_station)
        @start_station = start_station

        # @paths - keys are the ids of destination stations, values are arrays
        # containing all paths going from start_station to that destination
        @paths = T.let(
          {}, T::Hash[Integer, RouteFinder::OldTrams::PathsBetweenTwoStations]
        )
        @paths = Station.all.each_with_object({}) do |station, acc|
          acc[station.id] = PathsBetweenTwoStations.new(@start_station, station)
        end

        # add the stations that are immediately next to start_station
        @start_station.outgoing_segments.each do |segment|
          @paths[segment.station_b.id].add_path(Path.new([segment]))
        end
      end

      sig { params(destination: Station, path: Path).void }
      def add_path(destination, path)
        @paths[destination.id]&.add_path(path)
      end

      sig { returns(T::Hash[Integer, T.nilable(Path)]) }
      def shortest_paths
        @paths.each_with_object({}) do |(id, pathsBetween), acc|
          acc[id] = pathsBetween.shortest
        end
      end
    end
  end
end
