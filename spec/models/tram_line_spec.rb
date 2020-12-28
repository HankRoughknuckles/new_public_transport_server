# frozen_string_literal: true

# typed: false
require 'rails_helper'

RSpec.describe TramLine, type: :model do
  it 'should have many segments' do
    segment = build(:segment)
    tram_line = create(:tram_line)
    tram_line.segments << segment

    expect(tram_line.segments).to eq [segment]
  end

  describe '.from_station_names' do
    it 'should persist the right name' do
      name = 'THE TRAM LINE NAME!'
      TramLine.from_station_names(name, true, %w[station_1 station_2])
      persisted = TramLine.find_by_name(name)

      expect(persisted.name).to eq name
    end

    describe 'persisting the outgoing flag' do
      it 'should work when true' do
        TramLine.from_station_names('foo', true, %w[station_1 station_2])
        persisted = TramLine.find_by_name('foo')

        expect(persisted.outgoing).to eq true
      end

      it 'should work when false' do
        TramLine.from_station_names('foo', false, %w[station_1 station_2])
        persisted = TramLine.find_by_name('foo')

        expect(persisted.outgoing).to eq false
      end
    end

    it 'should add the stations properly' do
      TramLine.from_station_names('foo', true, %w[station_1 station_2])

      expect(Station.find_by_name('station_1')).to be_present
      expect(Station.find_by_name('station_2')).to be_present
    end

    describe 'adding the segments' do
      it 'should make segments from the first station to the last' do
        TramLine.from_station_names('Foo line', true, %w[station_1 station_2 station_3])
        first_station = Station.find_by_name('station_1')
        second_station = Station.find_by_name('station_2')
        third_station = Station.find_by_name('station_3')

        segment12 = Segment.where(station_a: first_station, station_b: second_station)
        expect(segment12).to be_present

        segment23 = Segment.where(station_a: second_station, station_b: third_station)
        expect(segment23).to be_present
      end

      it 'should not make backward segments' do
        TramLine.from_station_names('Foo line', true, %w[station_1 station_2])
        first_station = Station.find_by_name('station_1')
        second_station = Station.find_by_name('station_2')

        segment = Segment.where(station_a: second_station, station_b: first_station)
        expect(segment).not_to be_present
      end

      it 'should make the segment belong to the proper line' do
        TramLine.from_station_names('Foo line', true, %w[station_1 station_2])
        first_station = Station.find_by_name('station_1')

        segment = Segment.where(station_a: first_station).first
        expect(segment.tram_line.name).to eq 'Foo line'
      end
    end
  end
end
