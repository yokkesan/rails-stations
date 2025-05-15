# frozen_string_literal: true

class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    # 検索処理
    # 検索キーワード
    if params[:keyword].present?
      @movies = @movies.where('name LIKE ? OR description LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    # 上映中 or 上映予定でフィルタ
    if params[:is_showing].present?
      @movies = @movies.where(is_showing: params[:is_showing])
    end

    # 最新の月間ランキング
    ranking = Ranking.where(ranking_type: 'monthly').order(rank_date: :desc).first

    @rankings =
      if ranking
        ranking.movie_rankings.includes(:movie).order(total_reservations: :desc)
      else
        []
      end
  end

  # 映画詳細ページ
  def show
    @movie = Movie.find(params[:id])
    @schedules = @movie.schedules.includes(:screen).order(:start_time)
    @reservations = Reservation.includes(:schedule, :sheet)
                               .where(schedule_id: @schedules.ids, date: Date.today..)
  end

  # 座席予約ページ
  def reservation
    return unless find_movie_or_redirect
    return unless validate_schedule_params
    return unless find_schedule_or_redirect

    load_sheets_and_reservations
    Rails.logger.debug "🔍 @schedule: #{@schedule.inspect}"
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
    if @schedule
      true
    else
      redirect_to movie_path(@movie), alert: 'スケジュールが見つかりません'
      false
    end
  end

  def load_sheets_and_reservations
    @sheets = Sheet.all
    @reservations = Reservation.where(schedule_id: @schedule.id, date: @date)
    Rails.logger.debug "@sheets: #{@sheets.inspect}"
    Rails.logger.debug "@reservations: #{@reservations.inspect}"
  end
end
