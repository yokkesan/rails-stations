module Admin
  class MoviesController < ApplicationController
    def index
      @movies = Movie.all  # 映画一覧
    end

    # 映画登録フォームを表示
    def new
      @movie = Movie.new
    end

    # 映画をデータベースに登録
    def create
      @movie = Movie.new(movie_params)

      if @movie.save
        flash[:notice] = "映画が登録されました"
        redirect_to admin_movies_path  # 登録後、映画一覧にリダイレクト
      else
        flash.now[:alert] = "登録に失敗しました: " + @movie.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity  # エラー時はフォームに戻す
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


    private

    def movie_params
      params.require(:movie).permit(:name, :year, :description, :image_url, :is_showing)
    end
  end
end