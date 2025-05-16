# frozen_string_literal: true

namespace :movie_rankings do
  desc '予約数に基づいて映画ランキングを更新する（daily / weekly / monthly）'
  task update: :environment do
    ranking_type = ENV['TYPE'] || 'monthly'
    today = Date.today

    config = {
      'daily' => { days: 0, name: '日間ランキング' },
      'weekly' => { days: 6, name: '週間ランキング' },
      'monthly' => { days: 29, name: '月間ランキング' }
    }[ranking_type]

    unless config
      puts "無効な TYPE です: #{ranking_type}"
      exit
    end

    start_date = today - config[:days]
    Rails.logger = Logger.new(Rails.root.join('log/cron.log')) if ENV['CRON'] == 'true'
    Rails.logger.info "[MovieRanking][#{ranking_type}] 集計開始 #{start_date}〜#{today}"

    # Ranking を取得または作成
    ranking = Ranking.find_or_create_by!(ranking_type: ranking_type, rank_date: today) do |r|
      r.name = config[:name]
    end

    # 映画ごとに予約数を集計
    counts = Reservation.joins(schedule: :movie)
                        .where(date: start_date..today)
                        .group('movies.id')
                        .order('count_all DESC')
                        .count

    counts.each do |movie_id, count|
      movie = Movie.find(movie_id)

      movie_ranking = MovieRanking.find_or_initialize_by(
        movie: movie,
        ranking: ranking,
        rank_date: today
      )

      movie_ranking.total_reservations = count
      movie_ranking.save!

      Rails.logger.info "[MovieRanking][#{ranking_type}] 保存: movie_id=#{movie.id}, total_reservations=#{count}"
    end

    Rails.logger.info "[MovieRanking][#{ranking_type}] 集計完了（#{counts.size}件）"
  end
end
