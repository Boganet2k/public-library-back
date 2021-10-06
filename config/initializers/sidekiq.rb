schedule_file = "config/schedule.yml"

p "Sidekiq init " + Sidekiq.server?.to_s
if File.exist?(schedule_file) && Sidekiq.server?
  p "Sidekiq init_1"
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end