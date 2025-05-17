# frozen_string_literal: true

class ReservationsController < ApplicationController
  def new
    return head(:bad_request) if missing_params?

    set_resources
    @reservation = Reservation.new
  end

  private

  def missing_params?
    params[:date].blank? || params[:sheet_id].blank?
  end

  def set_resources
    @schedule = Schedule.find(params[:schedule_id])
    @movie = @schedule.movie
    @sheet = Sheet.find(params[:sheet_id])
    @date = params[:date]
  end

  def create
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      # メール送信処理（現在一時停止中）
      # ReservationMailer.confirmation_email(@reservation).deliver_now

      redirect_to movie_path(@reservation.schedule.movie_id), notice: '予約が完了しました'
    else
      set_reservation_context
      render :new, status: :unprocessable_entity
    end
  end

  def reservation_params
    params.require(:reservation).permit(:schedule_id, :sheet_id, :name, :email, :date)
  end

  def set_reservation_context
    @schedule = @reservation.schedule
    @movie    = @schedule.movie if @schedule
    @sheet    = @reservation.sheet
    @date     = @reservation.date
  end
end
