require 'twitter'

class TwitterAPI
  
  def self.tweet_as_dailyshoot(text, options={})
    twitter = TwitterAPI.new(ENV['TWITTER_CONSUMER_KEY'], 
    						 ENV['TWITTER_CONSUMER_SECRET'],
    						 ENV['TWITTER_POST_TOKEN'],
    						 ENV['TWITTER_POST_SECRET'])
    twitter.client.update(text, options)
  end
  
  attr_accessor :client
  
  def initialize(consumer_key=ENV['TWITTER_CONSUMER_KEY'],
                 consumer_secret=ENV['TWITTER_CONSUMER_SECRET'],
                 access_token=ENV['TWITTER_ACCESS_TOKEN'],
                 access_secret=ENV['TWITTER_ACCESS_SECRET'])
                 
    oauth = Twitter::OAuth.new(consumer_key, consumer_secret)
    oauth.authorize_from_access(access_token, access_secret)
    @client = Twitter::Base.new(oauth)    
  end
  
  def mentions(options = {})
    @client.mentions(options)
  end
  
  def tweets
    tweets = @client.user_timeline.select do |tweet| 
      tweet.text =~ /^\d{4}\/\d{2}\/\d{2}:/
    end
    tweets[0..2]
  end

# NEUTERING FOR NOW 
  
#  def tweet(text, options={})
#    @client.update(text, options)
#  end
  
end