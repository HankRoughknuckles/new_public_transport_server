# typed: false
FactoryBot.define do
  factory :station do
    sequence(:name) { |n| "Station #{n}" }
    simple_name {}
  end
end
