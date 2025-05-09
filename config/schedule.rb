# ENV['TZ'] = 'Asia/Tokyo'
set :environment, 'development'

every 1.day, at: '7:00 pm', environment_variables: { 'TZ' => 'Asia/Tokyo' } do
  rake 'reservation:send_reminder', output: 'log/cron.log'
end