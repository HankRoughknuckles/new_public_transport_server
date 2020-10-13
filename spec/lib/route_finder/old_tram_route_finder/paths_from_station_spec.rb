# typed: false
require 'rails_helper'
require './lib/route_finder'
include RouteFinder::OldTramRouteFinder

describe RouteFinder::OldTramRouteFinder::PathsFromStation do
  describe 'the initialization process' do
    describe 'when making the paths hash' do
        let!(:start_station) { create(:station) }
        let!(:destination_1) { create(:station) }
        let!(:paths_from_station) { PathsFromStation.new(start_station) }

      it 'should have keys equal to the destination station ids' do
        expect(paths_from_station.paths[destination_1.id]).to be_present
      end

      it 'should store a PathsBetweenTwoStations in the value' do
        value = paths_from_station.paths[destination_1.id]

        expect(value.class)
          .to eq RouteFinder::OldTramRouteFinder::PathsBetweenTwoStations
        expect(value.end_station).to eq destination_1
      end
    end
  end

  describe 'add_path' do
    pending 'should add the path'
    pending 'should do nothing when destination is not in the @paths array'
  end

  describe 'shortest_paths' do
    pending 'should return a hash of paths'
  end
end
