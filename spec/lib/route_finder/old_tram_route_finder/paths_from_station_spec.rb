# typed: false
require 'rails_helper'
require './lib/route_finder'
include RouteFinder::OldTramRouteFinder

describe RouteFinder::OldTramRouteFinder::PathsFromStation do
  describe 'the initialization process' do
    pending 'should set up the paths array correctly'
  end

  describe 'add_path' do
    pending 'should do nothing when destination is not in the @paths array'
  end

  describe 'shortest_paths' do
    pending 'should return a hash of paths'
  end
end
