class WelcomeController < ApplicationController

  def index
    response.headers['Cache-Control'] = 'public, max-age=600'
    twitter = TwitterAPI.new
    @assignment = Assignment.today
    @assignment = Assignment.first if @assignment == nil
    @photos = Photo.most_recent(30)
    @photog_count = Photog.count
    @photos_count = Photo.count
    @assignment_count = Assignment.published.count
  end
  
end
