class AddTheaterToScreens < ActiveRecord::Migration[7.0]
  def change
    add_reference :screens, :theater, foreign_key: true
  end
end