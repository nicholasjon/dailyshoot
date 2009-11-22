class WelcomeController < ApplicationController

  def index
  end
  
  def tweets
    tweets = Tweets.new
    @mentions = tweets.mentions
  end
  
end
