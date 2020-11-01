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
    it 'should return the path from @paths that has the shortest travel_time' do
      shorter_path = Path.new([create(:segment)])
      shorter_path.stub(:travel_time).with(1)
      longer_path = Path.new([create(:segment)])
      longer_path.stub(:travel_time).with(1)
      # shorter_path = double()
      # allow(shorter_path).to receive(:travel_time).and_return(1)
      # longer_path = double()
      # allow(longer_path).to receive(:travel_time).and_return(5)

      paths_between_two_stations = PathsBetweenTwoStations.new(create(:station), create(:station))
      paths_between_two_stations.add_path(shorter_path)
      paths_between_two_stations.add_path(longer_path)

      expect(paths_between_two_stations.shortest).to eq shorter_path
    end
  end
end
