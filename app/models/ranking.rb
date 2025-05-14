class Ranking < ApplicationRecord
  has_many :movie_rankings, dependent: :destroy
  has_many :movies, through: :movie_rankings
end