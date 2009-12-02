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

    httpauth = Twitter::HTTPAuth.new('username', 'password')
    client = Twitter::Base.new(httpauth)

    FakeWeb.register_uri(:get, url, {:body => File.read(file_path)})

    collector = TweetCollector.new
    collector.debug = true
    
    client.mentions.each_with_index do |raw_mention, index|
      collector.collect(raw_mention, index)
    end
  end
end