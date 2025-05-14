class CreateRankings < ActiveRecord::Migration[7.1]
  def change
    create_table :rankings do |t|
      t.string :name
      t.date :rank_date, null: false

      t.timestamps
    end
  end
end