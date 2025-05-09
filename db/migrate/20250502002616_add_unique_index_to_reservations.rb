class AddUniqueIndexToReservations < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, [:schedule_id, :sheet_id, :date], unique: true
  end
end
