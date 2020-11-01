# typed: false
require 'rails_helper'

RSpec.describe Segment, type: :model do
  it 'should require a station_a' do
    segment = build(:segment, station_a: nil)
    segment.valid?

    expect(segment.errors[:station_a]).to eq ['must exist', 'can\'t be blank']
  end

  it 'should require a station_b' do
    segment = build(:segment, station_b: nil)
    segment.valid?

    expect(segment.errors[:station_b]).to eq ['must exist', 'can\'t be blank']
  end

  it 'should require a tram line' do
    segment = build(:segment, tram_line: nil)
    segment.valid?

    expect(segment.errors[:tram_line]).to eq ['must exist', 'can\'t be blank']
  end

  it 'should have a working station_a relation' do
    station_a = Station.create(name: 'a')
    station_b = Station.create(name: 'b')
    segment = Segment.new(station_a: station_a, station_b: station_b)

    expect(segment.station_a).to eq station_a
  end

  it 'should have a working station_b relation' do
    station_a = Station.create(name: 'a')
    station_b = Station.create(name: 'b')
    segment = Segment.new(station_a: station_a, station_b: station_b)

    expect(segment.station_b).to eq station_b
  end

  it 'should have a working tram line relation' do
    tram_line = TramLine.create(name: '1', outgoing: true)
    station_a = Station.create(name: 'a')
    station_b = Station.create(name: 'b')
    segment = Segment.new(station_a: station_a, station_b: station_b, tram_line: tram_line)

    expect(segment.tram_line).to eq tram_line
  end
end
