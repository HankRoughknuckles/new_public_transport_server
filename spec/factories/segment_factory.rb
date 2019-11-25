FactoryBot.define do
  factory :segment do
    association :station_a, factory: :station
    association :station_b, factory: :station
    travel_time { 10 }
  end
end
