# frozen_string_literal: true

module Admin
  class MoviesController < ApplicationController
    layout 'admin'
    def index
      @movies = Movie.all

      # 検索キーワードで絞り込み（タイトル or 概要に含まれる）
      if params[:keyword].present?
        @movies = @movies.where('name LIKE :keyword OR description LIKE :keyword', keyword: "%#{params[:keyword]}%")
      end

      # 上映状況でフィルタリング
      @movies = @movies.where(is_showing: params[:is_showing]) if params[:is_showing].present?

      respond_to(&:html)
    end

    # 映画登録フォームを表示
    def new
      @movie = Movie.new
    end

    # **追加: 映画詳細ページ**
    def show
      @movie = Movie.includes(:schedules).find(params[:id])
      @schedules = @movie.schedules
      @reservations = Reservation.includes(:schedule, :sheet)
                                 .where(schedule_id: @schedules.ids, date: Date.today..)
    end

    # 映画をデータベースに登録
    def create
      @movie = Movie.new(movie_params)

      if @movie.save
        redirect_success
      else
        render_failure(:new, '登録に失敗しました')
      end
    rescue StandardError => e
      render_error(:new, e.message)
    end

    private

    def redirect_success
      flash[:notice] = '映画が登録されました'
      redirect_to admin_movies_path
    end

    def render_failure(view, message)
      flash.now[:alert] = "#{message}: #{@movie.errors.full_messages.join(', ')}"
      render view, status: :unprocessable_entity
    end

    def render_error(view, error_message)
      flash.now[:alert] = "エラーが発生しました: #{error_message}"
      render view, status: :internal_server_error
    end

    # 映画編集フォームを表示
    def edit
      @movie = Movie.find(params[:id])
    end

    # 映画情報を更新
    def update
      @movie = Movie.find(params[:id])

      if @movie.update(movie_params)
        redirect_success
      else
        render_failure(:edit, '更新に失敗しました')
      end
    rescue StandardError => e
      render_error(:edit, e.message)
    end

    # 映画を削除する
    def destroy
      movie = Movie.find(params[:id])
      movie.destroy
      flash[:notice] = '映画が削除されました'
      redirect_to admin_movies_path, status: :see_other
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = '映画が見つかりませんでした'
      head :not_found
    rescue StandardError => e
      flash[:alert] = "削除に失敗しました: #{e.message}"
      redirect_to admin_movies_path, status: :internal_server_error
    end

    def movie_params
      params.require(:movie).permit(:name, :year, :description, :image_url, :is_showing)
    end
  end
end
