# frozen_string_literal: true

FactoryBot.define do
  factory :movie_ranking do
    association :movie
    association :ranking
    rank_date { Date.today }
    total_reservations { 5 }
  end
end
