require 'rails_helper'

RSpec.describe Segment, type: :model do
  it 'should have a working station_a' do
    station_a = Station.create
    station_b = Station.create
    segment = Segment.create(station_a: station_a, station_b: station_b)

    expect(segment.station_a).to eq station_a
  end

  it 'should have a working station_b' do
    station_a = Station.create
    station_b = Station.create
    segment = Segment.create(station_a: station_a, station_b: station_b)

    expect(segment.station_b).to eq station_b
  end
end
