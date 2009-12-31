task :cron do
  Rake::Task['db:clean'].invoke
end