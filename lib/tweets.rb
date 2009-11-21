require 'twitter'

class Tweets
  
  def initialize
    @httpauth = Twitter::HTTPAuth.new('dailyshoot', 'grek4woycs8e')
  end
  
  def doit
    client = Twitter::Base.new(@httpauth)
    puts client.followers.size
    client.mentions.each { |tweet| puts tweet.text }
  end
  
end