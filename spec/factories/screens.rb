# frozen_string_literal: true

FactoryBot.define do
  factory :screen do
    name { "スクリーン#{rand(1..100)}" }
    association :theater
  end
end
