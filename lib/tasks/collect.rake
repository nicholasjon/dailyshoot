require 'fakeweb'
namespace :collect do

  desc "Collect tweets and create photos and photogs"
  task :tweets => :environment do
    require 'tweet_collector'
    TweetCollector.new.run
  end
  
  desc "Collect tweets and create photos and photogs from a local file"
  task :test => :environment do
    url = 'http://username:password@twitter.com:80/statuses/mentions.json'
    file_path = File.expand_path(File.dirname(__FILE__) + '/../../db/tweets.json')

    twitter = TwitterAPI.new('username', 'password')
    
    FakeWeb.register_uri(:get, url, {:body => File.read(file_path)})

    collector = TweetCollector.new(twitter)
    collector.debug = true
    
    client.mentions.each_with_index do |raw_mention, index|
      collector.collect(raw_mention, index)
    end
  end
  
  desc "Collect tweets and create photos and photogs from a local file"
  task :mock => :environment do
    page1_url = 'http://username:password@twitter.com:80/statuses/mentions.json?page=1'
    page1_file = File.expand_path(File.dirname(__FILE__) + '/../../db/mentions-page-1.json')

    FakeWeb.register_uri(:get, page1_url, {:body => File.read(page1_file)})

    twitter = TwitterAPI.new('username', 'password')

    collector = TweetCollector.new(twitter)
    collector.debug = true
    collector.run(1)
  end
  
end