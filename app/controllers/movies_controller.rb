# frozen_string_literal: true

class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    apply_keyword_filter
    apply_showing_filter
    load_latest_monthly_ranking
  end

  def show
    @movie = Movie.find(params[:id])
    @schedules = @movie.schedules.includes(:screen).order(:start_time)
    @reservations = Reservation.includes(:schedule, :sheet)
                               .where(schedule_id: @schedules.ids, date: Date.today..)
  end

  def reservation
    return unless find_movie_or_redirect
    return unless validate_schedule_params
    return unless find_schedule_or_redirect

    load_sheets_and_reservations
    Rails.logger.debug "🔍 @schedule: #{@schedule.inspect}"
  end

  private

  def apply_keyword_filter
    return unless params[:keyword].present?

    keyword = "%#{params[:keyword]}%"
    @movies = @movies.where('name LIKE ? OR description LIKE ?', keyword, keyword)
  end

  def apply_showing_filter
    return unless params[:is_showing].present?

    @movies = @movies.where(is_showing: params[:is_showing])
  end

  def load_latest_monthly_ranking
    ranking = Ranking.where(ranking_type: 'monthly').order(rank_date: :desc).first
    @rankings = ranking ? ranking.movie_rankings.includes(:movie).order(total_reservations: :desc) : []
  end

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
