# frozen_string_literal: true

class CreateScreens < ActiveRecord::Migration[7.1]
  def change
    create_table :screens do |t|
      t.string :name

      t.timestamps
    end
  end
end
