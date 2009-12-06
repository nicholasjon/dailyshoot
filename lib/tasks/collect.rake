namespace :collect do

  desc "Collect tweets and create photos and photogs"
  task :tweets => :environment do
    puts "Collecting tweets at #{Time.now}"
    require 'tweet_collector'
    collector = TweetCollector.new(TwitterAPI.new)
    collector.debug = true
    collector.run
  end
    
  desc "Collect tweets and create photos and photogs from a local file"
  task :test => :environment do
    
    # only need fakeweb in testing, not in production up on heroku
    require 'fakeweb'
    
    url = 'http://username:password@twitter.com:80/statuses/mentions.json'
    file_path = File.expand_path(File.dirname(__FILE__) + '/../../db/tweets.json')

    FakeWeb.register_uri(:get, url, {:body => File.read(file_path)})

    twitter = TwitterAPI.new('username', 'password')
    
    collector = TweetCollector.new(twitter)
    collector.debug = true

    count = 0    
    twitter.mentions.each_with_index do |raw_mention, index|
      if collector.collect(raw_mention)
        count += 1
        puts "#{count}. #{raw_mention.user.screen_name} #{raw_mention.text}"
      end  
    end
  end
  
end