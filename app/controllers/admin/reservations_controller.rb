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

    def update
      @reservation = Reservation.find(params[:id])
      if @reservation.update(reservation_params)
        redirect_success
      else
        render_failure
      end
    rescue StandardError => e
      render_error(e)
    end

    private

    def reservation_params
      params.require(:reservation).permit(:date, :name, :email, :schedule_id, :sheet_id)
    end

    def redirect_success
      flash[:notice] = '予約を更新しました'
      redirect_to admin_reservations_path
    end

    def render_failure
      flash.now[:alert] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end

    def render_error(error)
      flash[:alert] = "エラー: #{error.message}"
      redirect_to admin_reservations_path, status: :internal_server_error
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

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
  end
end
