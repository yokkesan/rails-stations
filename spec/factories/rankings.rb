# frozen_string_literal: true

FactoryBot.define do
  factory :ranking do
    ranking_type { 'daily' }
    rank_date { Date.today }
    name { '日間ランキング' }
  end
end
