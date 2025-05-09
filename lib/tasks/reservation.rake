namespace :reservation do
  desc '前日リマインドメールを送信するタスク'
  task send_reminder: :environment do
    target_date = Date.tomorrow
    Rails.logger.info "[リマインド] #{target_date} の予約に対してリマインドメール送信処理を開始します"

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

    Rails.logger.info "[リマインド] 全リマインドメール処理が完了しました"
  end
end