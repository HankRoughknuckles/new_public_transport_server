# typed: false
require 'rails_helper'
require './lib/route_finder'
include RouteFinder::OldTramRouteFinder

describe RouteFinder::OldTramRouteFinder::Path do
  describe '#include?' do
    it 'should return false if @segments is empty' do
      expect(Path.new([]).include?(create(:station))).to eq false
    end

    it 'should return true if the station is in the path' do
      station = create(:station)
      segments = [
        create(:segment, station_b: station),
        create(:segment, station_a: station), # station is 2nd one in the path
        create(:segment)
      ]

      expect(Path.new(segments).include?(station)).to eq true
    end

    it 'should return false if station is not in the path' do
      station = create(:station)
      segments = [
        create(:segment),
        create(:segment), # station is not here
        create(:segment)
      ]

      expect(Path.new(segments).include?(station)).to eq false
    end
  end

  describe '#final_station' do
    it 'should return nil if @segments is empty' do
      expect(Path.new([]).final_station).to eq nil
    end

    it 'should return the last station in the path' do
      station = create(:station)
      segments = [
        create(:segment),
        create(:segment, station_b: station) # station is the last one
      ]

      expect(Path.new(segments).final_station).to eq station
    end

    it 'should return that last station even when there is only one segment in the path' do
      station = create(:station)
      segments = [
        create(:segment, station_b: station)
      ]

      expect(Path.new(segments).final_station).to eq station
    end
  end

  describe '#travel_time' do
    it 'should return zero if @segments is empty' do
      expect(Path.new([]).travel_time).to eq 0
    end

    it 'should add the travel times of all the segments if theyre on the same tram line' do
      tram_line = create(:tram_line)
      segments = [
        create(:segment, tram_line: tram_line, travel_time: 1),
        create(:segment, tram_line: tram_line, travel_time: 1),
        create(:segment, tram_line: tram_line, travel_time: 1)
      ]

      expect(Path.new(segments).travel_time).to eq 3
    end

    it 'should add a delay if you have to change tram lines' do
      # this simulates getting off a tram and waiting for your next connection
      # to arrive
      tram_line_1 = create(:tram_line)
      tram_line_2 = create(:tram_line)
      segments = [
        create(:segment, tram_line: tram_line_1, travel_time: 1),
        create(:segment, tram_line: tram_line_2, travel_time: 1), # change trams
        create(:segment, tram_line: tram_line_2, travel_time: 1)
      ]

      expect(Path.new(segments).travel_time).to eq 3 + Path::TRAM_CHANGE_DELAY
    end

    it 'should add delay for each tram change' do
      # this simulates getting off a tram and waiting for your next connection
      # to arrive each time
      tram_line_1 = create(:tram_line)
      tram_line_2 = create(:tram_line)
      tram_line_3 = create(:tram_line)
      segments = [
        create(:segment, tram_line: tram_line_1, travel_time: 1),
        create(:segment, tram_line: tram_line_2, travel_time: 1), # change trams
        create(:segment, tram_line: tram_line_3, travel_time: 1) # change again
      ]

      expect(Path.new(segments).travel_time).to eq 3 + Path::TRAM_CHANGE_DELAY + Path::TRAM_CHANGE_DELAY
    end
  end

  describe "#stations" do
    it 'should return [] if @segments is empty' do
      expect(Path.new([]).stations).to eq []
    end

    it 'should return an array corresponding to the stations in the segments' do
      station_1 = create(:station)
      station_2 = create(:station)
      station_3 = create(:station)
      segments = [
        create(:segment, station_a: station_1, station_b: station_2), # station 1 -> 2
        create(:segment, station_a: station_2, station_b: station_3) # station 2 -> 3
      ]

      expect(Path.new(segments).stations).to eq [station_1, station_2, station_3]
    end
  end
end
