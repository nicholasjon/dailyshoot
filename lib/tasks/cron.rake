task :cron do
  
  puts "RAKE CRON PID #{Process.pid}; PARENT #{Process.ppid}"
  
  Rake::Task['cron_daily'].invoke if Time.now.hour == 0
  
  puts "----------------------------------------------------"
  puts "rake cron: Invoking Hourly Tasks // #{Time.now}"
  puts "----------------------------------------------------"
  
  Rake::Task['collect:tweets'].invoke  
  Rake::Task['send:assignment'].invoke if Time.now.hour == 16
  #Rake::Task['send:assignment'].invoke if Time.now.hour == 6 || Time.now.hour == 16
  
  if Time.now.hour == 17
    puts "FOOOOOOOF"
  end
end

task :cron_daily do
  
  Rake::Task['cron_monthly'].invoke if Time.now.day == 1
  Rake::Task['cron_weekly'].invoke if Time.now.wday == 1
  
  puts "----------------------------------------------------"
  puts "rake cron: Invoking Daily Tasks // #{Time.now}"
  puts "----------------------------------------------------"
  
  Rake::Task['db:clean'].invoke
  
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