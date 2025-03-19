class MoviesController < ApplicationController
    def index
      @movies = Movie.all  # movies テーブルの全データを取得
    end
  end