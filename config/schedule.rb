# frozen_string_literal: true

ENV['TZ'] = 'Asia/Tokyo'
set :environment, 'development'
# メール送信処理
every 1.day, at: '4:00 pm' do
  command '/bin/bash -l -c "/app/script/cron_remind.sh >> /app/log/cron.log 2>&1"'
end
# ランキング集計処理
every 1.day, at: '4:00 pm' do
  command '/bin/bash -l -c "/app/script/cron_movie_ranking.sh >> /app/log/cron.log 2>&1"'
end
