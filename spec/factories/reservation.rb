# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    association :schedule
    association :sheet
    sequence(:name) { |n| "TEST_USER#{n}" }
    sequence(:email) { |n| "test_email#{n}@test.com" }
    date { Date.today }
  end
end
