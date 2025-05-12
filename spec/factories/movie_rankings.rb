# frozen_string_literal: true

FactoryBot.define do
  factory :movie_ranking do
    movie { nil }
    total_reservations { 1 }
    rank_date { '2025-05-11' }
  end
end
