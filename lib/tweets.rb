require 'twitter'

class Tweets
  
  def initialize
    httpauth = Twitter::HTTPAuth.new('dailyshoot', ENV['DAILYSHOOT_TWITTER_PASS'])
    @client = Twitter::Base.new(httpauth)
  end
  
  def mentions(options = {:count => 8})
    @client.mentions(options)
  end
  
  def tweets
    tweets = @client.user_timeline.select do |tweet| 
      tweet.text =~ /^\d{4}\/\d{2}\/\d{2}:/
    end
    tweets[0..2]
  end
  
end