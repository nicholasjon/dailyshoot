require 'fakeweb'
namespace :collect do

  desc "Collect tweets and create photos and photogs"
  task :tweets => :environment do
    require 'tweet_collector'
    TweetCollector.new.run
  end
  
  desc "Collect tweets and create photos and photogs from a local file"
  task :tweets_local => :environment do
    url = 'http://username:password@twitter.com:80/statuses/mentions.json'
    file_path = File.expand_path(File.dirname(__FILE__) + '/../../db/tweets.json')

    httpauth = Twitter::HTTPAuth.new('username', 'password')
    client = Twitter::Base.new(httpauth)

    FakeWeb.register_uri(:get, url, {:body => File.read(file_path)})

    client.mentions.each_with_index do |mention, index|
      tweet = Tweet.new(mention)
      if tweet.save
        puts "#{index}. #{tweet.photog.screen_name} #{tweet.assignment.tag}"
      else
        if tweet.hashtag.nil?
          puts "No hashtag: #{mention.text}"
        elsif tweet.assignment.nil?
          puts "Unknown assignment tag: #{tweet.hashtag}"
        elsif tweet.photo.nil?
          puts "Could not parse tweet: #{mention.text}" 
        else
          puts "Unable to save photo: #{tweet.photo.inspect}"
        end
      end
    end
  end
  
end