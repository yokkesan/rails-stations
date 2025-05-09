# ENV['TZ'] = 'Asia/Tokyo' ← コメントアウトOK

set :environment, 'development'
set :output, 'log/cron.log'

every 1.day, at: '7:00 pm', environment_variables: { 'TZ' => 'Asia/Tokyo' } do
  rake 'reservation:send_reminder', output: 'log/cron.log'
end