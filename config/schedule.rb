# frozen_string_literal: true

env :BUNDLE_GEMFILE, '/app/Gemfile'
env :BUNDLE_PATH, '/usr/local/bundle'
env :RAILS_ENV, 'production'

set :output, '/app/log/cron.log'
set :environment, 'production'

# リマインドメール
every 1.day, at: '19:00 pm' do
  rake 'reservation:send_reminder'
end

# 毎日 0:00 に 日次ランキングを集計
every 1.day, at: '12:00 am' do
  rake 'movie_rankings:update TYPE=daily CRON=true'
end

# 毎週 月曜 0:00 に 週間ランキングを集計
every :monday, at: '12:00 am' do
  rake 'movie_rankings:update TYPE=weekly CRON=true'
end

# 毎月 1日 0:00 に 月間ランキングを集計
every '0 0 1 * *' do
  rake 'movie_rankings:update TYPE=monthly CRON=true'
end
