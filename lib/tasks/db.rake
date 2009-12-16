namespace :db do
  task :clean => :environment do
    puts "Cleaning up session table, deleting sessions stale after 1 week"
    sessions = ActiveRecord::SessionStore::Session::find(:all, :conditions => "updated_at < (current_timestamp - interval '1 week')")
    
    sessions.each do |session|
      session.destroy
    end
    
    puts "Cleaned up #{sessions.size} sessions"
  end  
end