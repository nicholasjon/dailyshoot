class WelcomeController < ApplicationController

  def index
    response.headers['Cache-Control'] = 'public, max-age=900'
    tweets = Tweets.new
    @mentions = tweets.mentions
  end
  
  def tweets
    tweets = Tweets.new
    @mentions = tweets.mentions
    @tweets = tweets.tweets
  end
  
  
  # for apps verification. Will kill soon enough.
  def google 
    render :text => "google8b45b5396fa7dfda"
  end
  
end
