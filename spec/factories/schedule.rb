# frozen_string_literal: true

FactoryBot.define do
  factory :schedule do
    association :movie
    association :screen
    start_time { Time.zone.parse('2025-05-04 10:00') }
    end_time   { Time.zone.parse('2025-05-04 12:00') }
  end
end
