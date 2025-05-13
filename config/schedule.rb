env :BUNDLE_GEMFILE, '/app/Gemfile'
env :BUNDLE_PATH, '/usr/local/bundle'
env :RAILS_ENV, 'production'

set :output, '/app/log/cron.log'
set :environment, 'production'

every 1.day, at: '2:15 pm' do
  rake 'reservation:send_reminder'
end

every 1.day, at: '2:15 pm' do
  rake 'movie_rankings:update'
end