# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :movie
  belongs_to :screen # ← スクリーンへの関連を追加
  has_many :reservations
  validates :start_time, presence: true
  validates :end_time, presence: true
end
