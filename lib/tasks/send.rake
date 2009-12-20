namespace :send do
  
  task :assignment => :environment do
    puts "SENDING out todays assignment"
    require 'twitter_api'
    twitter = TwitterAPI.new()
    twitter.tweet Assignment.today.as_tweet
  end

end