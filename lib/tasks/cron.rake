task :cron do
  Rake::Task['cron_daily'].invoke if Time.now.hour == 0
  
  puts "----------------------------------------------------"
  puts "rake cron: Invoking Hourly Tasks // #{Time.now}"
  puts "----------------------------------------------------"
  
  Rake::Task['collect:tweets'].invoke  
end

task :cron_daily do
  
  Rake::Task['cron_monthly'].invoke if Time.now.day == 1
  Rake::Task['cron_weekly'].invoke if Time.now.wday == 1
  
  puts "----------------------------------------------------"
  puts "rake cron: Invoking Daily Tasks // #{Time.now}"
  puts "----------------------------------------------------"
  
end

task :cron_weekly do
  
  puts "----------------------------------------------------"
  puts "rake cron: Invoking Weekly Tasks // #{Time.now}"
  puts "----------------------------------------------------"
  
end

task :cron_monthly do 
  
  puts "----------------------------------------------------"
  puts "rake cron: Invoking Monthly Tasks // #{Time.now}"
  puts "----------------------------------------------------"
  
end