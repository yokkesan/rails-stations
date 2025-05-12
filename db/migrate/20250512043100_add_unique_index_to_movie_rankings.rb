class AddUniqueIndexToMovieRankings < ActiveRecord::Migration[7.1]
  def change
    add_index :movie_rankings, [:movie_id, :rank_date], unique: true
  end
end
