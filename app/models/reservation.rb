# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :schedule
  belongs_to :sheet
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'が正しい形式ではありません' }
  validates :date, presence: true
  validates :schedule_id, presence: true
  validates :sheet_id, presence: true

  # 🔽 修正ポイント：同じ screen_id 内でユニーク制約をかける
  validate :unique_reservation_within_screen

  private

  def unique_reservation_within_screen
    return if schedule.nil?

    if Reservation.joins(:schedule)
                  .where(
                    schedules: { screen_id: schedule.screen_id },
                    sheet_id: sheet_id,
                    date: date
                  )
                  .where.not(id: id)
                  .exists?
      errors.add(:base, 'その座席はすでに予約されています（同一スクリーン内）')
    end
  end
end
