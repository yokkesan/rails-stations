# frozen_string_literal: true

env :BUNDLE_GEMFILE, '/app/Gemfile'
env :BUNDLE_PATH, '/usr/local/bundle'
env :RAILS_ENV, 'production'

set :output, '/app/log/cron.log'
set :environment, 'production'

every 1.day, at: '1:00 pm' do
  rake 'reservation:send_reminder'
end

every 1.day, at: '1:00 am' do
  rake 'movie_rankings:update'
end
