class AddScreenIdToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :schedules, :screen_id, :bigint
    add_foreign_key :schedules, :screens
    add_index :schedules, :screen_id
  end
end