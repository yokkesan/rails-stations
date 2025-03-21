module Admin
  class MoviesController < ApplicationController
    def index
      @movies = Movie.all

      # 検索キーワードで絞り込み（タイトル or 概要に含まれる）
      if params[:keyword].present?
        @movies = @movies.where("name LIKE :keyword OR description LIKE :keyword", keyword: "%#{params[:keyword]}%")
      end

      # 上映状況でフィルタリング
      if params[:is_showing].present?
        @movies = @movies.where(is_showing: params[:is_showing])
      end

      respond_to do |format|
        format.html # `index.html.erb` を適用
      end
    end

    # 映画登録フォームを表示
    def new
      @movie = Movie.new
    end

    # **追加: 映画詳細ページ**
    def show
      @movie = Movie.includes(:schedules).find(params[:id]) 
    end


    # 映画をデータベースに登録
    def create
      @movie = Movie.new(movie_params)

      if @movie.save
        flash[:notice] = "映画が登録されました"
        redirect_to admin_movies_path
      else
        flash.now[:alert] = "登録に失敗しました: " + @movie.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    rescue StandardError => e
      flash.now[:alert] = "エラーが発生しました: #{e.message}"
      render :new, status: :internal_server_error
    end

    # 映画編集フォームを表示
    def edit
      @movie = Movie.find(params[:id])
    end

    # 映画情報を更新
    def update
      @movie = Movie.find(params[:id])

      if @movie.update(movie_params)
        flash[:notice] = "映画情報が更新されました"
        redirect_to admin_movies_path
      else
        flash.now[:alert] = "更新に失敗しました: " + @movie.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    rescue StandardError => e
      flash.now[:alert] = "エラーが発生しました: #{e.message}"
      render :edit, status: :internal_server_error
    end

    # 映画を削除する
    def destroy
      movie = Movie.find(params[:id])
      movie.destroy
      flash[:notice] = "映画が削除されました"
      redirect_to admin_movies_path, status: :see_other
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "映画が見つかりませんでした"
      head :not_found
    rescue StandardError => e
      flash[:alert] = "削除に失敗しました: #{e.message}"
      redirect_to admin_movies_path, status: :internal_server_error
    end

    private

    def movie_params
      params.require(:movie).permit(:name, :year, :description, :image_url, :is_showing)
    end
  end
end