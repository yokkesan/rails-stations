# frozen_string_literal: true

class ChangeUsersNameNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :name, false
  end
end
