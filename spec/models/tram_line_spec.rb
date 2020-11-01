require 'rails_helper'

RSpec.describe TramLine, type: :model do
  it 'should have many segments' do
    segment = build(:segment)
    tram_line = create(:tram_line)
    tram_line.segments << segment

    expect(tram_line.segments).to eq [segment]
  end

  describe '.from_station_names' do
    it 'should persist a new tram_line with the right name and outgoing flag' do
      output = TramLine.from_station_names('foo', true, ['station_1', 'station_2'])
      persisted = TramLine.find_by_name('foo')

      expect(output).to eq persisted
      expect(output.outgoing).to be true
    end

    it 'should add the stations properly' do
      output = TramLine.from_station_names('foo', true, ['station_1', 'station_2'])

      expect(Station.find_by_name('station_1')).to be_present
      expect(Station.find_by_name('station_2')).to be_present
    end

    it 'should add the segments properly' do
    end
  end
end
