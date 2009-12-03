class WelcomeController < ApplicationController

  def index
    response.headers['Cache-Control'] = 'public, max-age=900'
    twitter = TwitterAPI.new
    #@mentions = twitter.mentions(:count => 8)
    #@tweets = twitter.tweets
    @assignment = Assignment.today
    @assignment = Assignment.first if @assignment == nil
    @photos = Photo.most_recent(30)
    @photog_count = Photog.count
    @photos_count = Photo.count
  end
  
  # for apps verification. Will kill soon enough.
  def google 
    render :text => "google8b45b5396fa7dfda"
  end
  
end
