# frozen_string_literal: true

# app/models/screen.rb
class Screen < ApplicationRecord
  has_many :schedules
end
