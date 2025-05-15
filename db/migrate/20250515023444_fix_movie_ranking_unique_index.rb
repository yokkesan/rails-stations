class FixMovieRankingUniqueIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :movie_rankings, name: 'index_movie_rankings_on_movie_id_and_rank_date'

    add_index :movie_rankings, [:movie_id, :ranking_id, :rank_date], unique: true, name: 'index_movie_rankings_on_movie_ranking_and_date'
  end
end