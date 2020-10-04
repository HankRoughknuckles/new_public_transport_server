require 'rails_helper'

RSpec.describe TramLine, type: :model do
  it 'should have many segments' do
    segment = build(:segment)
    tram_line = create(:tram_line)
    tram_line.segments << segment

    expect(tram_line.segments).to eq [segment]
  end
end
