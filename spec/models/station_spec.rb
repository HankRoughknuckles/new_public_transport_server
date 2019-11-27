require 'rails_helper'

RSpec.describe Station, type: :model do
  describe 'creating' do
    it 'should remove diacritics from name and put simplified into simple_name' do
      expect(Station.create(name: 'Petřiny').simple_name).to eq 'Petriny'
      expect(Station.create(name: 'Prašný most').simple_name).to eq 'Prasny most'
    end
  end

  describe '#neighbors' do
    it 'should return the other stations where this station is station_a in segment' do
      this_station = Station.create(name: 'foo')
      neighbor_1 = Station.create(name: 'bar')
      Segment.create(station_a: this_station, station_b: neighbor_1)

      neighbor_2 = Station.create(name: 'baz')
      Segment.create(station_a: this_station, station_b: neighbor_2)

      expect(this_station.neighbors).to eq [neighbor_1, neighbor_2]
    end
  end

  describe '#add_neighbor' do
    it 'should create a segment with this station as station_a' do
      this_station = Station.create(name: 'foo')
      neighbor = Station.create(name: 'bar')
      this_station.add_neighbor(neighbor, 10)

      expect(Segment.find_by(station_a: this_station)).to be_truthy
      expect(Segment.find_by(station_b: neighbor)).to be_truthy
    end

    it 'should create a segment with this station as station_b' do
      this_station = Station.create(name: 'foo')
      neighbor = Station.create(name: 'bar')
      this_station.add_neighbor(neighbor, 10)

      expect(Segment.find_by(station_a: neighbor, station_b: this_station)).to be_truthy
    end
  end
end
