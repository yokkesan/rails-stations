# frozen_string_literal: true

namespace :movie_rankings do
  desc '過去30日分の予約数に基づいて映画ランキングを更新する'
  task update: :environment do
    # cron経由の実行時にのみ cron.log へ出力
    Rails.logger = Logger.new(Rails.root.join('log/cron.log')) if ENV['CRON'] == 'true'

    begin
      today = Date.today
      start_date = today - 30
      now = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')

      Rails.logger.info "[MovieRanking] 集計処理開始（#{now}）: #{start_date}〜#{today}"

      # 今日のランキングを示す Ranking を取得または作成
      ranking = Ranking.find_or_create_by!(name: '日次ランキング', rank_date: today)

      # 今日のランキングを削除（再集計のため）
      deleted_count = MovieRanking.where(rank_date: today, ranking_id: ranking.id).delete_all
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
          ranking_id: ranking.id,
          total_reservations: count,
          rank_date: today
        )
        Rails.logger.info "[MovieRanking] 登録: movie_id=#{movie_id}, total_reservations=#{count}"
      end

      done_time = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')
      Rails.logger.info "[MovieRanking] 集計処理完了（#{counts.size} 件、完了時刻: #{done_time}）"
    rescue StandardError => e
      Rails.logger.error "[MovieRanking] エラー発生: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise e
    end
  end
end