require 'twitter'

class TwitterAPI
  
  def initialize(username='dailyshoot', password=ENV['DAILYSHOOT_TWITTER_PASS'])
    httpauth = Twitter::HTTPAuth.new(username, password)
    @client = Twitter::Base.new(httpauth)
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
  
end