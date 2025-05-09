# frozen_string_literal: true

module Admin
  class ReservationsController < ApplicationController
    before_action :set_reservation, only: %i[show edit update destroy]

    # GET /admin/reservations
    def index
      @reservations = Reservation.includes(schedule: :movie, sheet: {}).order('schedules.start_time ASC')
    end

    # GET /admin/reservations/new
    def new
      @reservation = Reservation.new
      @movies = Movie.all
      @schedules = Schedule.all
      @sheets = Sheet.all
    end

    # POST /admin/reservations
    def create
      @reservation = Reservation.new(reservation_params)

      if Reservation.exists?(schedule_id: @reservation.schedule_id, sheet_id: @reservation.sheet_id,
                             date: @reservation.date)
        head :bad_request  # ←ここを修正してテスト通過
      elsif @reservation.save
        redirect_to admin_reservations_path, notice: '予約を登録しました'
      else
        head :bad_request  # ←保存失敗時も400にする
      end
    end

    # GET /admin/reservations/:id/edit
    def edit
      @movies = Movie.all
      @schedules = Schedule.all
      @sheets = Sheet.all
    end

    # PUT /admin/reservations/:id
    def update
      exists = Reservation.where.not(id: @reservation.id).exists?(
        schedule_id: reservation_params[:schedule_id],
        sheet_id: reservation_params[:sheet_id],
        date: reservation_params[:date]
      )
      if exists
        redirect_to admin_reservations_path, alert: 'その座席はすでに予約されています'
      elsif @reservation.update(reservation_params)
        redirect_to admin_reservations_path, notice: '予約を更新しました'
      else
        redirect_to admin_reservations_path, alert: '予約の更新に失敗しました'
      end
    end

    # DELETE /admin/reservations/:id
    def destroy
      @reservation.destroy
      redirect_to admin_reservations_path, notice: '予約を削除しました'
    end

    def show
      @movies = Movie.all
      @schedules = Schedule.all
      @sheets = Sheet.all
    end

    private

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:schedule_id, :sheet_id, :name, :email, :date)
    end
  end
end
