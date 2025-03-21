class Reservation < ApplicationRecord
  belongs_to :schedule
  belongs_to :sheet

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: "が正しい形式ではありません" }
  validates :date, presence: true
  validates :schedule_id, presence: true
  validates :sheet_id, presence: true

  # ユニーク制約（1つのスケジュール・日付に対して同じ座席は予約できない）
  validates :schedule_id, uniqueness: { scope: [:sheet_id, :date], message: "その座席はすでに予約されています" }
end