# frozen_string_literal: true

class ReservationsController < ApplicationController
  def new
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

    if @reservation.save
      # メール送信は一時停止中（上限に達したため）
      # ReservationMailer.confirmation_email(@reservation).deliver_now

      redirect_to movie_path(@reservation.schedule.movie_id), notice: '予約が完了しました'
    else
      @schedule = @reservation.schedule
      @movie = @schedule.movie if @schedule
      @sheet = @reservation.sheet
      @date = @reservation.date
      render :new, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:schedule_id, :sheet_id, :name, :email, :date)
  end

  def reservation_path_with_params(reservation)
    movie_id = reservation.schedule&.movie_id
    schedule_id = reservation.schedule_id
    date = reservation.date
    "/movies/#{movie_id}/reservation?schedule_id=#{schedule_id}&date=#{date}"
  end
end
