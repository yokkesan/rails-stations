# frozen_string_literal: true

namespace :reservation do
  desc '前日リマインドメールを送信するタスク'
  task send_reminder: :environment do
    Rails.logger = Logger.new(Rails.root.join('log/cron.log')) if ENV['CRON'] == 'true'

    target_date = Date.tomorrow
    now = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')
    Rails.logger.info "[===== リマインド処理開始 #{target_date}（実行時刻: #{now}） =====]"

    reservations = Reservation.where(date: target_date)
    Rails.logger.info "[リマインド] 対象予約件数: #{reservations.count} 件"

    reservations.find_each do |reservation|
      mail = ReservationMailer.reminder_email(reservation)
      mail.deliver_now
      Rails.logger.info "[送信成功] ID:#{reservation.id}, Email:#{reservation.email}, MsgID:#{mail.message_id}, JST時刻:#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S %:z')}"
    rescue StandardError => e
      Rails.logger.error "[送信失敗] ID:#{reservation.id}, Email:#{reservation.email}, エラー:#{e.message}"
    end

    done_time = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')
    Rails.logger.info "[===== リマインド処理完了 #{target_date}（完了時刻: #{done_time}） =====]"
  end
end
