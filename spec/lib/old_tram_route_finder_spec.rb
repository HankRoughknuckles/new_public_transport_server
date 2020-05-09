require 'rails_helper'
require 'old_tram_route_finder'

describe 'old_tram_route_finder' do
  it 'should work' do
    create(:station, name: 'a')
    create(:station, name: 'b')
    expect(initialize_nexts).to eq []
  end
end
