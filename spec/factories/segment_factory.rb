# frozen_string_literal: true

# typed: false
FactoryBot.define do
  factory :segment do
    association :tram_line, factory: :tram_line
    association :station_a, factory: :station
    association :station_b, factory: :station
    travel_time { 10 }
  end
end
