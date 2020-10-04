module RouteFinder
  module OldTrams
    # TODO: tests
    class PathsFromStation
      extend T::Sig

      sig { params(start_station: Station).void }
      def initialize(start_station)
        @start_station = start_station
      end
    end
  end
end
