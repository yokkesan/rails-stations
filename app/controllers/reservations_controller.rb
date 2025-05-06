# frozen_string_literal: true

class ReservationsController < ApplicationController
  def new
    # dateとsheet_idがなければ400 Bad Requestで返す（テスト通過のため）
    if params[:date].blank? || params[:sheet_id].blank?
      head :bad_request
      return
    end

    @schedule = Schedule.find(params[:schedule_id])
    @movie = @schedule.movie
    @sheet = Sheet.find(params[:sheet_id])
    @date = params[:date]
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)

    # 重複チェック
    if Reservation.exists?(schedule_id: @reservation.schedule_id,
                          sheet_id: @reservation.sheet_id,
                          date: @reservation.date)
      movie_id = @reservation.schedule.movie_id
      schedule_id = @reservation.schedule_id
      date = @reservation.date
      redirect_to "/movies/#{movie_id}/reservation?schedule_id=#{schedule_id}&date=#{date}",
                  alert: 'その座席はすでに予約済みです'
    elsif @reservation.save
      # メール送信を追加
      ReservationMailer.confirmation_email(@reservation).deliver_now
      redirect_to movie_path(@reservation.schedule.movie_id), notice: '予約が完了しました'
    else
      # バリデーションなどに失敗した場合
      redirect_back fallback_location: '/', alert: '予約に失敗しました'
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:schedule_id, :sheet_id, :name, :email, :date)
  end
end
