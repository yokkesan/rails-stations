# frozen_string_literal: true

module Admin
  class SchedulesController < ApplicationController
    before_action :set_schedule, only: %i[show edit update destroy]

    def index
      @theaters = Theater.all
      if params[:theater_id].present?
        screens = Screen.where(theater_id: params[:theater_id])
        @schedules = Schedule.where(screen_id: screens.select(:id)).includes(:movie, :screen).order(:start_time)
        @selected_theater_id = params[:theater_id]
      else
        @schedules = Schedule.includes(:movie, :screen).order(:start_time)
        @selected_theater_id = nil
      end
    end

    def show
      @schedule = Schedule.find(params[:id])
      @movie = @schedule.movie
    end

    def new
      @movie = Movie.find(params[:movie_id])
      @schedule = @movie.schedules.build
      @screens = @movie.theater.screens
    end

    def create
      @schedule = Schedule.new(schedule_params)

      if @schedule.save
        flash[:notice] = 'スケジュールが登録されました'
        redirect_to admin_schedules_path
      else
        puts '=== バリデーションエラー ==='
        puts @schedule.errors.full_messages

        @movie = Movie.find(schedule_params[:movie_id])
        @screens = @movie.theater.screens

        flash.now[:alert] = '登録に失敗しました'
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @schedule.update(schedule_params)
        flash[:notice] = 'スケジュールが更新されました'
        redirect_to admin_schedules_path
      else
        flash.now[:alert] = '更新に失敗しました'
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @schedule.destroy
      flash[:notice] = 'スケジュールが削除されました'
      redirect_to admin_schedules_path, status: :see_other
    end

    private

    def set_schedule
      @schedule = Schedule.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'スケジュールが見つかりませんでした'
      redirect_to admin_schedules_path, status: :see_other
    end

    def schedule_params
      params.require(:schedule).permit(:movie_id, :start_time, :end_time, :screen_id)
    end
  end
end