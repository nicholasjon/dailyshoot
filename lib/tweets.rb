require 'twitter'

class Tweets
  
  def initialize
    httpauth = Twitter::HTTPAuth.new('dailyshoot', ENV['DAILYSHOOT_TWITTER_PASS'])
    @client = Twitter::Base.new(httpauth)
  end
  
  def mentions
    @client.mentions(:count => 10)
  end
  
  def tweets
    tweets = @client.user_timeline.select do |tweet| 
      tweet.text =~ /^\d{4}\/\d{2}\/\d{2}:/
    end
    tweets[0..9]
  end
  
end