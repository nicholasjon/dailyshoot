require 'twitter'

class Tweets
  
  def initialize
    httpauth = Twitter::HTTPAuth.new('dailyshoot', 'grek4woycs8e')
    @client = Twitter::Base.new(httpauth)
  end
  
  def mentions
    @client.mentions[0..9]
  end
  
end