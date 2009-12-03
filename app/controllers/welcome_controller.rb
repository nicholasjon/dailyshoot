class WelcomeController < ApplicationController

  def index
    response.headers['Cache-Control'] = 'public, max-age=900'
    tweets = Tweets.new
    
    # TODO make this today's assignment, not just the most recent
    @assignment = Assignment.first :order => "date DESC" 
    @photos = Photo.all :limit => 30, :order => "created_at DESC"
    
   # @mentions = [] #tweets.mentions
  #  @tweets = [] #tweets.tweets
  end
  
  # for apps verification. Will kill soon enough.
  def google 
    render :text => "google8b45b5396fa7dfda"
  end
  
end
