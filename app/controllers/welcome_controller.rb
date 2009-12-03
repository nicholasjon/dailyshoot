class WelcomeController < ApplicationController

  def index
    response.headers['Cache-Control'] = 'public, max-age=900'
    twitter = TwitterAPI.new
    #@mentions = twitter.mentions(:count => 8)
    #@tweets = twitter.tweets
    @assignment = Assignment.today
    @photos = Photo.most_recent(30)
  end
  
  # for apps verification. Will kill soon enough.
  def google 
    render :text => "google8b45b5396fa7dfda"
  end
  
end
