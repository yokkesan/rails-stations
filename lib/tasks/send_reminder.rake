# namespace :reservation do
#     desc '予約リマインドメールを送信する'
#     task send_reminder: :environment do
#     target_date = Date.tomorrow

#     reservations = Reservation.where(date: target_date)

#     reservations.each do |reservation|
#         ReservationMailer.reminder_email(reservation).deliver_now
#         puts "Sent reminder to #{reservation.email}"
#     end
#     end
# end