class Movie < ApplicationRecord
  has_many :schedules, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
