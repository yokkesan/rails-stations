# frozen_string_literal: true

class MoviesController < ApplicationController
  def index
    @movies = Movie.all

    # 検索処理
    if params[:keyword].present?
      @movies = @movies.where('name LIKE ? OR description LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    # 上映状況でフィルタリング
    return unless params[:is_showing].present?

    @movies = @movies.where(is_showing: params[:is_showing])
  end

  # 映画詳細ページ
  def show
    @movie = Movie.find(params[:id])
    @schedules = @movie.schedules
    @reservations = Reservation.includes(:schedule, :sheet)
                               .where(schedule_id: @schedules.ids, date: Date.today..)
  end

  # 座席予約ページ
  def reservation
    find_movie_or_redirect and return
    validate_schedule_params or return
    find_schedule_or_redirect and return
    load_sheets_and_reservations
  end

  private

  def find_movie_or_redirect
    @movie = Movie.find_by(id: params[:movie_id] || params[:id])
    return true if @movie

    redirect_to movies_path, alert: '指定された映画が見つかりません'
    false
  end

  def validate_schedule_params
    if params[:schedule_id].blank? || params[:date].blank?
      redirect_to movie_path(@movie), alert: '日付とスケジュールを選択してください'
      return false
    end
    @date = params[:date]
    true
  end

  def find_schedule_or_redirect
    @schedule = Schedule.find_by(id: params[:schedule_id])
    return true if @schedule

    redirect_to movie_path(@movie), alert: 'スケジュールが見つかりません'
    false
  end

  def load_sheets_and_reservations
    @sheets = Sheet.all
    @reservations = Reservation.where(schedule_id: @schedule.id, date: @date)
    Rails.logger.debug "@sheets: #{@sheets.inspect}"
    Rails.logger.debug "@reservations: #{@reservations.inspect}"
  end
end
