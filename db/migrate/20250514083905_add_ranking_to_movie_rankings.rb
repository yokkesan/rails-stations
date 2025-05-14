class AddRankingToMovieRankings < ActiveRecord::Migration[7.1]
  def change
    add_reference :movie_rankings, :ranking, null: false, foreign_key: true
  end
end
