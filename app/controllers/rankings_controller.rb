# frozen_string_literal: true

class RankingsController < ApplicationController
  def index
    @selected_date = parse_date(params[:date])
    @ranking_type = params[:ranking_type].presence || 'daily'

    @ranking = Ranking.find_by(rank_date: @selected_date, ranking_type: @ranking_type)

    @rankings =
      if @ranking
        @ranking.movie_rankings.includes(:movie).order(total_reservations: :desc)
      else
        []
      end
  end

  private

  def parse_date(date_param)
    Date.parse(date_param) rescue Date.today
  end
end