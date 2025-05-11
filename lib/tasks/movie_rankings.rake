# encoding: utf-8
namespace :movie_rankings do
  desc "過去30日分の予約数に基づいて映画ランキングを更新する"
  task update: :environment do
    today = Date.today
    start_date = today - 30

    Rails.logger.info "[MovieRanking] 集計処理開始: #{start_date}〜#{today}"

    # 既存の今日のランキングを削除（再集計のため）
    deleted_count = MovieRanking.where(rank_date: today).delete_all
    Rails.logger.info "[MovieRanking] 本日分のランキングを削除: #{deleted_count}件"

    # 過去30日間の予約数を movie_id ごとに集計
    counts = Reservation.joins(schedule: :movie)
                        .where(date: start_date..today)
                        .group('movies.id')
                        .order('count_all DESC')
                        .count

    counts.each do |movie_id, count|
      MovieRanking.create!(
        movie_id: movie_id,
        total_reservations: count,
        rank_date: today
      )
      Rails.logger.info "[MovieRanking] 登録: movie_id=#{movie_id}, total_reservations=#{count}"
    end

    Rails.logger.info "[MovieRanking] 集計処理完了（#{counts.size} 件）"
  end
end