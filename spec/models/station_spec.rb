# typed: false
require 'rails_helper'

RSpec.describe Station, type: :model do
  describe 'creating' do
    it 'should remove diacritics from name and put simplified into simple_name' do
      expect(create(:station, name: 'Petřiny').simple_name).to eq 'Petriny'
      expect(create(:station, name: 'Prašný most').simple_name).to eq 'Prasny most'
    end
  end

  describe '#neighbors' do
    it 'should return the other stations where this station is station_a in segment' do
      this_station = create(:station)
      neighbor_1 = create(:station)
      neighbor_2 = create(:station)
      create(:segment, station_a: this_station, station_b: neighbor_1)
      create(:segment, station_a: this_station, station_b: neighbor_2)

      expect(this_station.neighbors).to eq [neighbor_1, neighbor_2]
    end

    it 'should remove any duplicate stations if there are multiple connecting lines' do
      this_station = create(:station)
      neighbor_1 = create(:station)
      tram_line_1 = create(:tram_line)
      tram_line_2 = create(:tram_line)
      create(:segment, station_a: this_station, station_b: neighbor_1, tram_line: tram_line_1)
      create(:segment, station_a: this_station, station_b: neighbor_1, tram_line: tram_line_2)

      expect(this_station.neighbors).to eq [neighbor_1]
    end
  end

  describe '#add_neighbor' do
    it 'should create a segment with this station as station_a' do
      this_station = create(:station)
      neighbor = create(:station)
      tram_line = create(:tram_line)
      this_station.add_neighbor(neighbor, tram_line, 10)

      expect(Segment.find_by(station_a: this_station)).to be_truthy
      expect(Segment.find_by(station_b: neighbor)).to be_truthy
    end

    it 'should create a segment with this station as station_b' do
      this_station = create(:station)
      neighbor = create(:station)
      tram_line = create(:tram_line)
      this_station.add_neighbor(neighbor, tram_line, 10)

      expect(Segment.find_by(station_a: neighbor, station_b: this_station)).to be_truthy
    end
  end

  describe '#outgoing_segments' do
    pending 'should show all segments where this station is the origin'
  end
end
