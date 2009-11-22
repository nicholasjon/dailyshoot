class WelcomeController < ApplicationController

  def index
  end
  
  def tweets
    tweets = Tweets.new
    @mentions = tweets.mentions
    @tweets = tweets.tweets
  end
  
end
