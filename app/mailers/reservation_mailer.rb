# frozen_string_literal: true

class ReservationMailer < ApplicationMailer
  default from: 'it.yteshim@gmail.com'
  # メール上限のため停止
  # def confirmation_email(reservation)
  #   @reservation = reservation
  #   mail(
  #     to: reservation.email,
  #     subject: '【予約完了】映画の予約内容をお知らせします'
  #   )
  # end

  def reminder_email(reservation)
    @reservation = reservation
    mail(
      to: reservation.email,
      subject: '【リマインド】明日の映画予約のお知らせ'
    )
  end
end
