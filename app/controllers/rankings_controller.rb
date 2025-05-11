
class RankingsController < ApplicationController
  def index
    if params[:date].present?
      selected_date = Date.parse(params[:date]) rescue Date.today
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