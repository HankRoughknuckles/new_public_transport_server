require 'rails_helper'

RSpec.describe Station, type: :model do
  describe '#neighbors' do
    it 'should return the other stations where this station is station_a in segment' do
      this_station = Station.create
      neighbor_1 = Station.create
      Segment.create(station_a: this_station, station_b: neighbor_1)

      neighbor_2 = Station.create
      Segment.create(station_a: this_station, station_b: neighbor_2)

      expect(this_station.neighbors).to eq [neighbor_1, neighbor_2]
    end
  end

  describe '#add_neighbor' do
    it 'should create a segment with this station as station_a' do
      this_station = Station.create
      neighbor = Station.create
      this_station.add_neighbor(neighbor, 10)

      expect(Segment.find_by(station_a: this_station)).to be_truthy
      expect(Segment.find_by(station_b: neighbor)).to be_truthy
    end

    it 'should create a segment with this station as station_b' do
      this_station = Station.create
      neighbor = Station.create
      this_station.add_neighbor(neighbor, 10)

      expect(Segment.find_by(station_a: neighbor, station_b: this_station)).to be_truthy
    end
  end
end
