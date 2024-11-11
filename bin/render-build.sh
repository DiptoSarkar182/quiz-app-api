#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Ruby gems
bundle install

# Run database migrations
bundle exec rails db:migrate

# Optionally, you can also seed the database if you have seed data
 bundle exec rails db:seed

# If you need to run any background jobs or other tasks, add them here
# bundle exec rails jobs:work  # Example: running background jobs, if needed
