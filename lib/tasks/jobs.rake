namespace :jobs do

  task :kick => [:environment, 'jobs:clear'] do
    puts "Resetting jobs"
    Delayed::Job.enqueue AssignmentSender.new
    Delayed::Job.enqueue TweetCollector.new
  end

end