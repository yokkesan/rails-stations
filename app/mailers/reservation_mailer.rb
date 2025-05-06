class ReservationMailer < ApplicationMailer
    default from: 'it.yteshim@gmail.com'
  
    def confirmation_email(reservation)
      @reservation = reservation
      mail(
        to: reservation.email,
        subject: '【予約完了】映画の予約内容をお知らせします'
      )
    end
  end