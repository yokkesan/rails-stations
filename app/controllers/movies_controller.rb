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

    respond_to do |format|
      format.html
    end
  end

  # 映画詳細ページ
  def show
    @movie = Movie.find(params[:id])
    @schedules = @movie.schedules
  end

  # 座席予約ページ
  def reservation
    @movie = Movie.find(params[:movie_id] || params[:id]) # movie_id がなければ id を使用
  
    # パラメータが足りない場合はリダイレクト
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
    # 予約済みの座席情報を取得
    @reservations = Reservation.where(schedule_id: @schedule.id, date: @date)
  end
end # ← **不足していた `end` を追加**