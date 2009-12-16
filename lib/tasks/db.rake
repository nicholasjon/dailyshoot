namespace :db do
  task :clean => :environment do
    puts "Cleaning up session table, deleting sessions stale after 1 week"
    ActiveRecord::Base.connection.delete(
    "DELETE FROM sessions WHERE updated_at < #{Date.today - 1.week}")
  end  
end