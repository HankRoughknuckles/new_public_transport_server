# typed: strict
require 'station'

module RouteFinderForOldTrams
  def shortest_path(start_station, end_station)
    shortest_paths_from_station(start_station)[end_station.id]
  end

  # sig { params(start_station: Station).returns(T::Hash[Integer, Path]) }
  def shortest_paths_from_station(start_station)
    all_paths = all_paths_from_station(start_station)
    all_paths.each_with_object({}) do |(id, pathsBetween), acc|
      acc[id] = pathsBetween.shortest_path
    end
  end

  def all_paths_from_station(start_station)
    paths_from_start = Station.all.reduce({}) do |acc, station|
      acc[station.id] = PathsBetweenTwoStations.new(start_station, station)
      acc
    end

    paths_to_check = start_station.outgoing_segments.map { |segment| Path.new([segment]) }
    start_station.outgoing_segments.each do |segment|
      paths_from_start[segment.station_b.id].add_path(Path.new([segment]))
    end

    paths_to_check.each do |path|
      final_station = path.final_station
      next_segments = final_station.outgoing_segments
      next_segments.each do |next_segment|
        next_station = next_segment.station_b
        if !path.include?(next_station)
          new_path = Path.new(path.segments + [next_segment])
          paths_from_start[next_station.id].add_path(new_path)
          paths_to_check << new_path
        end
      end
    end

    return paths_from_start
  end

  class PathsFromStation
    extend T::Sig

    sig { params(start_station: Station).void }
    def initialize(start_station)
      @start_station = start_station
    end
  end

  # TODO: dockblock + put in own file
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

    # sig { returns(Path) }
    def shortest_path
      @paths.reduce(OpenStruct.new({travel_time: Float::INFINITY})) do |smallest, path|
        path.travel_time < smallest.travel_time ? path : smallest
      end
    end
  end

  # TODO: extract to own file
  # TODO: tests
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

  # # THE NEW ALGORITHM - hopefully should work
  # For starting node N_s
  #   put all outgoing segments from N_s into paths_to_check
  #   for each path P in paths_to_check
  #     for each outgoing segment from the final station in P
  #       if the destination of the segment isn't already in the path taken
  #         put P + final_segment into list of all paths from N_s
  #         append P + final_segment to the paths_to_check list


  # def initialize_distances
  #   stations = Station.all.to_a
  #   infinite_distances = stations.map do |station|
  #     [station.id, Float::INFINITY]
  #   end.to_h
  #
  #   distances_by_station = stations.reduce({}) do |memo, station|
  #     memo[station.id] = infinite_distances.clone
  #     memo[station.id][station.id] = 0 # set distance to self to 0
  #     memo
  #   end
  # end
  #
  # def initialize_nexts(*args)
  #   stations = Station.all.to_a
  #   stations_at_nil = stations.map do |station|
  #     [station.id, nil]
  #   end.to_h
  #
  #   stations.reduce({}) do |memo, station|
  #     memo[station.id] = stations_at_nil.clone
  #     # intiialize the "next" station to get to self to be self
  #     memo[station.id][station.id] = station.id
  #     memo
  #   end
  # end
  #
  # def old_tram_route_finder
  #   distances = initialize_distances
  #   nexts = initialize_nexts
  #
  #   # =========================
  #   # Floyd Warshall pseudocode
  #   # =========================
  #   # let dist be a |V| x |V| array of minimum distances initialized to infinity
  #   # let next be a |V| x |V| array of vertex indices initialized to null
  #   #
  #   # procedure FloydWarshallWithPathReconstruction() is
  #   #     for each edge (u, v) do
  #   #         dist[u][v] ← w(u, v)  // The weight of the edge (u, v)
  #   #         next[u][v] ← v
  #   #     for each vertex v do
  #   #         dist[v][v] ← 0
  #   #         next[v][v] ← v
  #   #     for k from 1 to |V| do // standard Floyd-Warshall implementation
  #   #         for i from 1 to |V|
  #   #             for j from 1 to |V|
  #   #                 if dist[i][j] > dist[i][k] + dist[k][j] then
  #   #                     dist[i][j] ← dist[i][k] + dist[k][j]
  #   #                     next[i][j] ← next[i][k]
  #   #
  #   # procedure Path(u, v)
  #   #     if next[u][v] = null then
  #   #         return []
  #   #     path = [u]
  #   #     while u ≠ v
  #   #         u ← next[u][v]
  #   #         path.append(u)
  #   #     return path
  # end
end
