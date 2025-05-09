namespace :reservation do
  desc '前日リマインドメールを送信するタスク'
  task send_reminder: :environment do
    target_date = Date.tomorrow

    reservations = Reservation.where(date: target_date)
    puts "#{reservations.count} 件の予約に対してリマインドメールを送信します"

    reservations.find_each do |reservation|
      mail = ReservationMailer.reminder_email(reservation)
      mail.deliver_now
      puts "送信: #{reservation.email}, メッセージID: #{mail.message_id}, 時刻: #{Time.zone.now}"
    end
  end
end
