ENV['TZ'] = 'Asia/Tokyo'
set :environment, 'development'

every 1.day, at: '11:00 am' do
  command '/bin/bash -l -c "/app/script/cron_remind.sh >> /app/log/cron.log 2>&1"'
end