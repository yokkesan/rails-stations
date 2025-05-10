# encoding: utf-8
namespace :reservation do
  desc '前日リマインドメールを送信するタスク'
  task send_reminder: :environment do
    if ENV['CRON'] == 'true'
      Rails.logger = Logger.new(Rails.root.join('log/cron.log'))
    end

    target_date = Date.tomorrow
    Rails.logger.info "[===== リマインド処理開始 #{target_date} =====]"

    reservations = Reservation.where(date: target_date)
    Rails.logger.info "[リマインド] 対象予約件数: #{reservations.count} 件"

    reservations.find_each do |reservation|
      begin
        mail = ReservationMailer.reminder_email(reservation)
        mail.deliver_now
        Rails.logger.info "[送信成功] ID:#{reservation.id}, Email:#{reservation.email}, MsgID:#{mail.message_id}, JST時刻:#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S %:z')}"
      rescue => e
        Rails.logger.error "[送信失敗] ID:#{reservation.id}, Email:#{reservation.email}, エラー:#{e.message}"
      end
    end

    Rails.logger.info "[===== リマインド処理完了 #{target_date} =====]"
  end
end