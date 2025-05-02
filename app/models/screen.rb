class Screen < ApplicationRecord
  belongs_to :theater
  has_many :schedules, dependent: :destroy
end