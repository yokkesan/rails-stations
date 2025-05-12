# frozen_string_literal: true

class RankingsController < ApplicationController
  def index
    if params[:date].present?
      selected_date = begin
        Date.parse(params[:date])
      rescue StandardError
        Date.today
      end
      @selected_date = selected_date
      @rankings = MovieRanking
                  .includes(:movie)
                  .where(rank_date: selected_date)
                  .order(total_reservations: :desc)
    else
      @selected_date = nil
      @rankings = []
    end
  end
end
