namespace :send do
  
  task :assignment => :environment do
    require 'twitter_api'
    twitter = TwitterAPI.new()
    #twitter.tweet Assignment.today.as_tweet
    twitter.tweet "Looking for the API in the twitter lib to set the client name to something other than 'API'"
  end

end