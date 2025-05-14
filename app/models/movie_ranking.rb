class MovieRanking < ApplicationRecord
  belongs_to :movie
  belongs_to :ranking
end