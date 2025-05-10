# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :schedule
  belongs_to :sheet

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'が正しい形式ではありません' }
  validates :date, presence: true
  validates :schedule_id, presence: true
  validates :sheet_id, presence: true

  # 独自バリデーション
  validate :unique_reservation_within_screen
  validate :date_matches_schedule

  private

  # 同一スクリーン・同一日付・同一座席の重複予約を禁止
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

  # 予約日とスケジュールの上映日を一致させる
  def date_matches_schedule
    return if schedule.nil? || date.nil?

    if date != schedule.start_time.to_date
      errors.add(:date, 'はスケジュールの上映開始日と一致する必要があります')
    end
  end
end