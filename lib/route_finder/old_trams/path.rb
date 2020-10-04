# TODO: tests
module RouteFinder
  module OldTrams
    class Path
      extend T::Sig
      attr_accessor :segments

      TRAM_CHANGE_DELAY = T.let(5 * 60, Integer) # 5 minutes

      sig { params(segments: T::Array[Segment]).void }
      def initialize(segments)
        @segments = segments
      end

      sig { returns(T.nilable(Station)) }
      def final_station
        @segments.last&.station_b
      end

      # TODO: write tests
      sig { params(station: Station).returns(T::Boolean) }
      def include?(station)
        stations = @segments.flat_map do |segment|
          [segment.station_a, segment.station_b]
        end
        stations.to_set.include? station
      end

      sig { returns(Integer) }
      def travel_time
        # TODO: guard against empty self.segments
        total_time = 0
        current_tram_line = @segments.first.tram_line
        @segments.each do |segment|
          total_time += (segment.travel_time || 0)

          if segment.tram_line != current_tram_line
            total_time += TRAM_CHANGE_DELAY
            current_tram_line = segment.tram_line
          end
        end

        return total_time
      end

      sig { returns(T::Array[Station]) }
      def to_a
        self.segments.map(&:station_a) + [self.final_station]
      end
    end
  end
end
