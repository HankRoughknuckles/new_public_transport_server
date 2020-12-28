# frozen_string_literal: true

# typed: false

require 'rails_helper'
require './lib/route_finder'

describe RouteFinder::OldTramRouteFinder do
  it 'should return nil when start and end destinations arent connected' do
    expect(RouteFinder::OldTramRouteFinder.shortest_path(create(:station), create(:station))).to eq nil
  end

  describe 'When A-B-C are all on the same line' do
    let(:station_a) { create(:station, name: 'a') }
    let(:station_b) { create(:station, name: 'b') }
    let(:station_c) { create(:station, name: 'c') }
    let(:tram_line) { create(:tram_line) }

    before do
      station_a.add_two_way_connection_with station_b, tram_line, 10
      station_b.add_two_way_connection_with station_c, tram_line, 10
    end

    it 'should show the shortest route from A-B as AB' do
      expect(RouteFinder::OldTramRouteFinder.shortest_path(station_a, station_b).stations)
        .to eq [station_a, station_b]
    end

    it 'should show the shortest route from B-C as BC' do
      expect(RouteFinder::OldTramRouteFinder.shortest_path(station_b, station_c).stations)
        .to eq [station_b, station_c]
    end

    it 'should show the shortest route from A-C as ABC' do
      expect(RouteFinder::OldTramRouteFinder.shortest_path(station_a, station_c).stations)
        .to eq [station_a, station_b, station_c]
    end
  end

  describe 'When A-B-C are in a triangle with AC shorter than ABC' do
    let(:station_a) { create(:station, name: 'a') }
    let(:station_b) { create(:station, name: 'b') }
    let(:station_c) { create(:station, name: 'c') }
    let(:tram_line) { create(:tram_line) }

    before do
      station_a.add_two_way_connection_with station_b, tram_line, 10
      station_b.add_two_way_connection_with station_c, tram_line, 10
      station_a.add_two_way_connection_with station_c, tram_line, 10
    end

    it 'should show the shortest route from A-B as AB' do
      expect(RouteFinder::OldTramRouteFinder.shortest_path(station_a, station_b).stations)
        .to eq [station_a, station_b]
    end

    it 'should show the shortest route from B-C as BC' do
      expect(RouteFinder::OldTramRouteFinder.shortest_path(station_b, station_c).stations)
        .to eq [station_b, station_c]
    end

    it 'should show the shortest route from A-C as AC' do
      expect(RouteFinder::OldTramRouteFinder.shortest_path(station_a, station_c).stations)
        .to eq [station_a, station_c]
    end
  end

  describe 'When A-B-C are in a triangle with AC longer than ABC' do
    let(:station_a) { create(:station, name: 'a') }
    let(:station_b) { create(:station, name: 'b') }
    let(:station_c) { create(:station, name: 'c') }
    let(:tram_line) { create(:tram_line) }

    before do
      station_a.add_two_way_connection_with station_b, tram_line, 10
      station_b.add_two_way_connection_with station_c, tram_line, 10
      station_a.add_two_way_connection_with station_c, tram_line, 30
    end

    it 'should show the shortest route from A-B as AB' do
      expect(RouteFinder::OldTramRouteFinder.shortest_path(station_a, station_b).stations)
        .to eq [station_a, station_b]
    end

    it 'should show the shortest route from B-C as BC' do
      expect(RouteFinder::OldTramRouteFinder.shortest_path(station_b, station_c).stations)
        .to eq [station_b, station_c]
    end

    it 'should show the shortest route from A-C as ABC' do
      expect(RouteFinder::OldTramRouteFinder.shortest_path(station_a, station_c).stations)
        .to eq [station_a, station_b, station_c]
    end
  end

  describe 'When A-B-C are in a triangle' do
    describe 'and AC and ABC are equidistant, but ABC requires a line change' do
      let(:station_a) { create(:station, name: 'a') }
      let(:station_b) { create(:station, name: 'b') }
      let(:station_c) { create(:station, name: 'c') }
      let(:line_1) { create(:tram_line) }
      let(:line_2) { create(:tram_line) }

      before do
        station_a.add_two_way_connection_with station_b, line_1, 10
        station_b.add_two_way_connection_with station_c, line_2, 10 # must transfer to line 2
        station_a.add_two_way_connection_with station_c, line_1, 20 # AC is equidistant to ABC
      end

      it 'should show the shortest route from A-B as AB' do
        expect(RouteFinder::OldTramRouteFinder.shortest_path(station_a, station_b).stations)
          .to eq [station_a, station_b]
      end

      it 'should show the shortest route from B-C as BC' do
        expect(RouteFinder::OldTramRouteFinder.shortest_path(station_b, station_c).stations)
          .to eq [station_b, station_c]
      end

      it 'should show the shortest route from A-C as AC' do
        expect(RouteFinder::OldTramRouteFinder.shortest_path(station_a, station_c).stations)
          .to eq [station_a, station_c]
      end
    end
  end
end
