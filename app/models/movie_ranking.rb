# frozen_string_literal: true

class MovieRanking < ApplicationRecord
  belongs_to :movie

  validates :movie_id, presence: true
  validates :rank_date, presence: true
  validates :total_reservations, presence: true,
                                 numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # 同一映画・同一日付で重複登録を防ぐ
  validates :rank_date, uniqueness: {
    scope: :movie_id,
    message: 'は同じ映画に対して重複登録できません'
  }
end
