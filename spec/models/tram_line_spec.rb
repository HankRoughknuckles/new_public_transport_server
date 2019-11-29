require 'rails_helper'

RSpec.describe TramLine, type: :model do
  describe '#segments' do
    it 'should return the segments in order' do
      # line goes from 1 to 2 to 3 - purposefully creating stations out of order
      # to verify that the order column in the segment_tram_line puts them in
      # the right order
      line_a = TramLine.create(name: 'backwards tram line from 3 to 1')
      station_2 = Station.create(name: '2')
      station_1 = Station.create(name: '1')
      station_3 = Station.create(name: '3')
      segment_2_3 = Segment.create(station_a: station_2, station_b: station_3)
      segment_1_2 = Segment.create(station_a: station_1, station_b: station_2)

      # 2nd segment in the tram line
      SegmentTramLine.create(segment: segment_2_3, tram_line: line_a, order: 2)
      # 1st segment in the tram line
      SegmentTramLine.create(segment: segment_1_2, tram_line: line_a, order: 1)

      expect(line_a.segments).to eq [segment_1_2, segment_2_3]
    end
  end
end
