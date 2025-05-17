# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :movie
  belongs_to :screen
  has_many :reservations
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :screen_schedule_must_be_unique

  private

  def screen_schedule_must_be_unique
    return if screen_id.blank? || start_time.blank? || movie_id.blank?

    return unless Schedule.exists?(screen_id: screen_id, start_time: start_time, movie_id: movie_id)

    errors.add(:base, '同じ時間・同じスクリーン・同じ映画のスケジュールは登録できません')
  end
end
