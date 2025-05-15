class Movie < ApplicationRecord
  belongs_to :theater
  has_many :schedules, dependent: :destroy
  has_many :movie_rankings, dependent: :destroy
  has_many :reservations, through: :schedules
  has_many :rankings, through: :movie_rankings
end