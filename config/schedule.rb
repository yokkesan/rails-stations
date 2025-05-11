ENV['TZ'] = 'Asia/Tokyo'
set :environment, 'development'
# メール送信処理
every 1.day, at: '11:00 am' do
  command '/bin/bash -l -c "/app/script/cron_remind.sh >> /app/log/cron.log 2>&1"'
end
# ランキング集計処理
every 1.day, at: '12:00 am' do
  command '/bin/bash -l -c "/app/script/cron_movie_ranking.sh >> /app/log/cron.log 2>&1"'
end