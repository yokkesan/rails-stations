class CreateMovieRankings < ActiveRecord::Migration[7.1]
  def change
    create_table :movie_rankings do |t|
      t.references :movie, null: false, foreign_key: true
      t.integer :total_reservations
      t.date :rank_date

      t.timestamps
    end
  end
end
