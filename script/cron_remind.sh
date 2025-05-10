#!/bin/bash
cd /app || exit 1
export BUNDLE_GEMFILE=/app/Gemfile
export RAILS_ENV=development
bundle check || bundle install
bin/rails runner "ENV['CRON']='true'; require 'rake'; Rails.application.load_tasks; Rake::Task['reservation:send_reminder'].invoke"