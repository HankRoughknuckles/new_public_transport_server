# typed: strict
require 'station'
require_relative 'old_trams/path'
require_relative 'old_trams/paths_between_two_stations'
require_relative 'old_trams/paths_from_station'

module RouteFinder
  module OldTrams
    extend T::Sig

    sig { params(start_station: Station, end_station: Station).returns(T.nilable(Path)) }
    def shortest_path(start_station, end_station)
      shortest_paths = all_paths_from_station(start_station).shortest_paths
      shortest_paths[end_station.id]
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
end
