#!/bin/bash
set -e

cron

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

ruby -v

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"