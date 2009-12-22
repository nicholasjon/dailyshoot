namespace :jobs do

  task :kick => [:environment, 'jobs:clear'] do
    puts "Resetting jobs"
    Delayed::Job.enqueue AssignmentSender.new
  end

end