#!/bin/bash
cd /app || exit 1
export BUNDLE_GEMFILE=/app/Gemfile
export RAILS_ENV=development
export RAILS_LOG_TO_STDOUT=true
bundle check || bundle install
bin/rails runner "ENV['CRON']='true'; require 'rake'; Rails.application.load_tasks; Rake::Task['movie_rankings:update'].invoke"