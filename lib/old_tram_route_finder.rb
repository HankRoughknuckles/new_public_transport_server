# typed: strict
require 'station'

def old_tram_route_finder

end

# TODO: write tests
def shortest_routes_from_station(start_station)
  paths_from_start = {}
  paths_to_check = start_station.outgoing_segments.map { |segment| Path.new([segment]) }

  paths_to_check.each do |path|
    final_station = path.final_station
    next_segments = final_station.outgoing_segments
    next_segments.each do |next_segment|
      next_station = next_segment.station_b
      if !path.include?(next_station)
        new_path = Path.new(path.segments + next_segment)
        paths_from_start[next_station.id] << new_path
        paths_to_check << new_path
      end
    end
  end
end

# TODO: extract to own file
class Path
  def initialize(segments)
    self.segments = segments
  end

  def final_station
    self.segments.last.station_b
  end

  # TODO: write tests
  def include?(station)
    stations_set = self.segments.flat_map({ |segment| [segment.station_a, segment.station_b] }).to_set
    stations_set.include? station
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
