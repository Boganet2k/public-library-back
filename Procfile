web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
worker: bundle exec sidekiq -e production -C config/schedule.yml
release: bundle exec rake db:migrate