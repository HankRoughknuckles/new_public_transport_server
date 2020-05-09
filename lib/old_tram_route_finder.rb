# typed: strict
require 'station'


INFINITY = -1

def initialize_distances
  stations = Station.all.to_a
  infinite_distances = stations.map do |station|
    [station.id, INFINITY]
  end.to_h

  distances_by_station = stations.reduce({}) do |memo, station|
    memo[station.id] = infinite_distances.clone
    memo[station.id][station.id] = 0 # set distance to self to 0
    memo
  end
end

def initialize_nexts(*args)
  stations = Station.all.to_a
  stations_at_nil = stations.map do |station|
    [station.id, nil]
  end.to_h

  stations.reduce({}) do |memo, station|
    memo[station.id] = stations_at_nil.clone
    # intiialize the "next" station to get to self to be self
    memo[station.id][station.id] = station.id
    memo
  end
end

def old_tram_route_finder
  distances = initialize_distances
  nexts = initialize_nexts

  # =========================
  # Floyd Warshall pseudocode
  # =========================
  # let dist be a |V| x |V| array of minimum distances initialized to infinity
  # let next be a |V| x |V| array of vertex indices initialized to null
  #
  # procedure FloydWarshallWithPathReconstruction() is
  #     for each edge (u, v) do
  #         dist[u][v] ← w(u, v)  // The weight of the edge (u, v)
  #         next[u][v] ← v
  #     for each vertex v do
  #         dist[v][v] ← 0
  #         next[v][v] ← v
  #     for k from 1 to |V| do // standard Floyd-Warshall implementation
  #         for i from 1 to |V|
  #             for j from 1 to |V|
  #                 if dist[i][j] > dist[i][k] + dist[k][j] then
  #                     dist[i][j] ← dist[i][k] + dist[k][j]
  #                     next[i][j] ← next[i][k]
  #
  # procedure Path(u, v)
  #     if next[u][v] = null then
  #         return []
  #     path = [u]
  #     while u ≠ v
  #         u ← next[u][v]
  #         path.append(u)
  #     return path
end
