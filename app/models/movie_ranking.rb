# frozen_string_literal: true

class MovieRanking < ApplicationRecord
  belongs_to :movie
  belongs_to :ranking

  validates :movie_id, presence: true
  validates :ranking_id, presence: true
  validates :rank_date, presence: true
  validates :total_reservations,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :movie_id, uniqueness: {
    scope: %i[ranking_id rank_date],
    message: 'はこのランキングにすでに登録されています'
  }
end
