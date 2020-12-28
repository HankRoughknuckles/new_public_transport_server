# frozen_string_literal: true

# typed: strict
module RouteFinder
  module OldTramRouteFinder
    # Represents a single path from a starting station to a destination station.
    class Path
      extend T::Sig

      sig { returns(T::Array[Segment]) }
      attr_accessor :segments

      # The estimated time one would have to wait if they changed trams in
      # a journey.  Represents the time spent waiting for their connection to
      # arrive.
      # Note, this is only used when calculating how much time you'd spend
      # changing trams in the middle of a journey.  It is NOT added to the front
      # of a journey to calculate how long you're waiting to get on the first tram
      # to begin a journey.
      TRAM_CHANGE_DELAY = T.let(5.minutes.to_i, Integer)

      sig { params(segments: T::Array[Segment]).void }
      def initialize(segments)
        @segments = T.let(segments, T::Array[Segment])
      end

      # the final station that's at the end of the path
      sig { returns(T.nilable(Station)) }
      def final_station
        @segments.last&.station_b
      end

      # whether the passed station is on the path
      sig { params(station: Station).returns(T::Boolean) }
      def include?(station)
        stations = @segments.flat_map do |segment|
          [segment.station_a, segment.station_b]
        end
        stations.to_set.include? station
      end

      # how long it would take to travel the path - If a transfer to another
      # tram line is necessary, this naively assumes that it would take on
      # average TRAM_CHANGE_DELAY seconds worth of waiting for each transfer
      sig { returns(Integer) }
      def travel_time
        return 0 if @segments.empty?

        current_tram_line = T.must(@segments.first).tram_line
        @segments.reduce(0) do |total_travel_time, segment|
          total_travel_time += (segment.travel_time || 0)

          # account for the delay it would take to change the tram line, if
          # needed
          if segment.tram_line != current_tram_line
            total_travel_time += TRAM_CHANGE_DELAY
            current_tram_line = segment.tram_line
          end

          total_travel_time
        end
      end

      # an array of all of the stations in the path in order from start to
      # finish
      sig { returns(T::Array[Station]) }
      def stations
        return [] if @segments.empty?

        segments.map(&:station_a) << T.must(final_station)
      end
    end
  end
end
