# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    sequence(:name) { |n| "テスト映画#{n}" }
    year { 2025 }
    is_showing { true }
    description { 'テスト用の映画です。' }
    image_url { 'https://example.com/sample.jpg' }
  end
end
