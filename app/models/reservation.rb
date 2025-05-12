# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :schedule
  belongs_to :sheet
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'が正しい形式ではありません' }
  validates :date, presence: true
  validates :schedule_id, presence: true
  validates :sheet_id, presence: true
  validates :schedule_id, uniqueness: { scope: [:sheet_id, :date], message: '・座席・日付の組み合わせはすでに存在します' }
  validate :date_matches_schedule

  private

  # 予約日とスケジュールの上映日を一致させる
  def date_matches_schedule
    return if schedule.nil? || date.nil?

    if date != schedule.start_time.to_date
      errors.add(:date, 'はスケジュールの上映開始日と一致する必要があります')
    end
  end
end