class AddTheaterToMovies < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:movies, :theater_id)
      add_reference :movies, :theater, foreign_key: true
    end
  end
end