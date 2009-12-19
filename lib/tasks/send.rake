namespace :send do
  
  task :assignment => :environment do
    require 'twitter_api'
    twitter = TwitterAPI.new()
    twitter.tweet Assignment.today.as_tweet
  end

end