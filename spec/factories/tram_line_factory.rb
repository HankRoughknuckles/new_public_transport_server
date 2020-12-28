# frozen_string_literal: true

# typed: false
FactoryBot.define do
  factory :tram_line do
    sequence(:name) { |n| "Line #{n}" }
    outgoing { true }
  end
end
