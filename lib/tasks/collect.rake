namespace :collect do
  desc "Collect tweets and create photos and photogs"
  task :tweets => :environment do
    require 'tweet_collector'
    TweetCollector.new.run
  end
end