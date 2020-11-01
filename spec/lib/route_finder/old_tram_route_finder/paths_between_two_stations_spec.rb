# typed: false
require 'rails_helper'
require './lib/route_finder'
include RouteFinder::OldTramRouteFinder

describe RouteFinder::OldTramRouteFinder::PathsBetweenTwoStations do
  describe '#[] operator' do
    it 'should access the @paths array' do
      paths_between_two_stations = PathsBetweenTwoStations.new(create(:station), create(:station))
      paths_between_two_stations.add_path(Path.new([create(:segment)]))
      paths_between_two_stations.add_path(Path.new([create(:segment)]))

      expect(paths_between_two_stations[0]).to be paths_between_two_stations.paths[0]
      expect(paths_between_two_stations[1]).to be paths_between_two_stations.paths[1]
    end
  end

  describe 'add_path' do
    it 'should append the path to the end of the list' do
      paths_between_two_stations = PathsBetweenTwoStations.new(create(:station), create(:station))
      path_to_be_added = Path.new([create(:segment)])

      paths_between_two_stations.add_path(path_to_be_added)

      expect(paths_between_two_stations.paths.last).to be path_to_be_added
    end
  end

  describe 'shortest' do
    it 'should return nil if @paths is empty' do
      paths_between_two_stations = PathsBetweenTwoStations.new(create(:station), create(:station))
      expect(paths_between_two_stations.shortest).to eq nil
    end

    it 'should return the path from @paths that has the shortest travel_time' do
      shorter = instance_double('RouteFinder::OldTramRouteFinder::Path', travel_time: 1)
      longer = instance_double('RouteFinder::OldTramRouteFinder::Path', travel_time: 5)
      paths_between_two_stations = PathsBetweenTwoStations.new(
        create(:station),
        create(:station)
      )
      paths_between_two_stations.add_path(longer)
      paths_between_two_stations.add_path(shorter)

      expect(paths_between_two_stations.shortest).to eq shorter
    end

    it 'should return the first one in the list if the times are the same' do
      first = instance_double('RouteFinder::OldTramRouteFinder::Path', travel_time: 1)
      second = instance_double('RouteFinder::OldTramRouteFinder::Path', travel_time: 1)
      paths_between_two_stations = PathsBetweenTwoStations.new(
        create(:station),
        create(:station)
      )
      paths_between_two_stations.add_path(first)
      paths_between_two_stations.add_path(second)

      expect(paths_between_two_stations.shortest).to eq first
    end
  end
end
