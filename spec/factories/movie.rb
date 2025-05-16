# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    name { 'テスト映画' }
    year { '2025' }
    description { 'テスト説明文' }
    is_showing { true }
    image_url { 'https://example.com/sample.jpg' }
    association :theater
  end
end
