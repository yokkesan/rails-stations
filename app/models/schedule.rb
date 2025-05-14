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
    return if screen_id.blank? || start_time.blank? || end_time.blank?

    overlap = Schedule.where(screen_id: screen_id)
                      .where.not(id: id)
                      .where('start_time < ? AND end_time > ?', end_time, start_time)
                      .exists?

    return unless overlap

    errors.add(:base, 'このスクリーン・時間帯には既に別作品のスケジュールがあります')
  end
end
