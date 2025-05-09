# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'バリデーション' do
    it '同一スクリーン・同一座席・同一日付で重複予約できないこと' do
      theater = create(:theater)
      screen = create(:screen, theater: theater)
      create(:movie)
      schedule = create(:schedule, screen: screen)
      sheet = create(:sheet)
      date = '2025-05-03'

      # 最初の予約
      create(:reservation, schedule: schedule, sheet: sheet, date: date)

      # 同じスクリーン・同じシート・同じ日付の別予約はエラーになる
      duplicate = build(:reservation, schedule: schedule, sheet: sheet, date: date)
      expect(duplicate.valid?).to be false
      expect(duplicate.errors[:base]).to include('その座席はすでに予約されています（同一スクリーン内）')
    end
  end
end
