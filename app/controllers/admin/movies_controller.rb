module Admin
    class MoviesController < ApplicationController
      def index
        @movies = Movie.all  # movies テーブルの全データ取得
      end
    end
  end