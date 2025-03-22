class MoviesController < ApplicationController
  def index
    @movies = Movie.all

    # 検索処理
    if params[:keyword].present?
      @movies = @movies.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    # 上映状況でフィルタリング
    if params[:is_showing].present?
      @movies = @movies.where(is_showing: params[:is_showing])
    end
  end

  # 映画詳細ページ
  def show
    @movie = Movie.find(params[:id])
    @schedules = @movie.schedules
  end

  # 座席予約ページ
  def reservation
    @movie = Movie.find_by(id: params[:movie_id] || params[:id])

    if @movie.nil?
      redirect_to movies_path, alert: "指定された映画が見つかりません"
      return
    end

    if params[:schedule_id].blank? || params[:date].blank?
      redirect_to movie_path(@movie), alert: "日付とスケジュールを選択してください"
      return
    end

    @date = params[:date]
    @schedule = Schedule.find_by(id: params[:schedule_id])

    unless @schedule
      redirect_to movie_path(@movie), alert: "スケジュールが見つかりません"
      return
    end

    @sheets = Sheet.all
    @reservations = Reservation.where(schedule_id: @schedule.id, date: @date)

    # デバッグ用ログを追加
    Rails.logger.debug "@sheets: #{@sheets.inspect}"
    Rails.logger.debug "@reservations: #{@reservations.inspect}"
  end
end