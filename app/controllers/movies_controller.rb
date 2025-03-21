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

    # 追加: HTMLビューを明示的にレンダリング
    respond_to do |format|
      format.html # `index.html.erb` を適用
    end
  end
end