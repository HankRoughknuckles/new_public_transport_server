# typed: false
require 'rails_helper'
require './lib/route_finder'
include RouteFinder::OldTramRouteFinder

describe RouteFinder::OldTramRouteFinder::PathsFromStation do
  describe 'the initialization process' do
    describe 'when making the paths hash' do
        let!(:start_station) { create(:station) }
        let!(:destination_1) { create(:station) }
        let!(:connecting_segment) do
          create(
            :segment,
            station_a: start_station,
            station_b: destination_1
          )
        end
        let!(:paths_from_station) { PathsFromStation.new(start_station) }

      it 'should have keys equal to the destination station ids' do
        expect(paths_from_station.all_paths_to(destination_1)).to be_present
      end

      it 'should store a PathsBetweenTwoStations in the value' do
        expect(paths_from_station.all_paths_to(destination_1).end_station)
          .to eq destination_1
      end

      it 'should initialize as having a path to each adjacent station' do
        expect(paths_from_station.all_paths_to(destination_1)[0].segments).to eq [connecting_segment]
      end
    end
  end

  describe 'add_path' do
    it 'should add the path' do
      start_station = create(:station)
      middle_station = create(:station)
      end_station = create(:station)
      start_to_middle = create(
        :segment,
        station_a: start_station,
        station_b: middle_station
      )
      middle_to_end = create(
        :segment,
        station_a: middle_station,
        station_b: end_station
      )
      path_to_destination = Path.new(
        [start_to_middle, middle_to_end]
      )
      paths_from_station = PathsFromStation.new(start_station)

      paths_from_station.add_path(end_station, path_to_destination)

      expect(paths_from_station.all_paths_to(end_station).paths)
        .to eq [path_to_destination]
    end

    it 'should do nothing when destination is not in the @paths array' do
      station = create(:station)
      paths_from_station = PathsFromStation.new(station)
      station_not_in_paths = create(:station) # not present bc was made post-init
      segment = create(
        :segment, station_a: station, station_b: station_not_in_paths
      )
      path = Path.new([segment])

      expect { paths_from_station.add_path(station_not_in_paths, path) }
        .not_to change { paths_from_station.all_paths_to(station_not_in_paths) }
    end
  end

  describe 'shortest_paths' do
    pending 'should return a hash of paths'
  end
end
