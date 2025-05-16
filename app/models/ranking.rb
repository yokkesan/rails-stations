# frozen_string_literal: true

class Ranking < ApplicationRecord
  has_many :movie_rankings, dependent: :destroy
  has_many :movies, through: :movie_rankings

  validates :ranking_type, presence: true, inclusion: { in: %w[daily weekly monthly] }
  validates :rank_date, presence: true
  validates :ranking_type, uniqueness: { scope: :rank_date, message: 'はこの日付ですでに存在します' }
end
