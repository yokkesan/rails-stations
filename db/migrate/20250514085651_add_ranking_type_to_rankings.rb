class AddRankingTypeToRankings < ActiveRecord::Migration[7.1]
  def change
    add_column :rankings, :ranking_type, :string
  end
end
