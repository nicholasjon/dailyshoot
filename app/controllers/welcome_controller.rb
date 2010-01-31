class WelcomeController < ApplicationController

  before_filter :set_cache_control, :only => [:index, :show, :services]

  def index
    twitter = TwitterAPI.new
    @assignment = Assignment.today
    @assignment = Assignment.first if @assignment == nil
    @photos = Photo.most_recent(30)
    @photog_count = Photog.count
    @photos_count = Photo.count
    @assignment_count = Assignment.published.count
  end
  
  def services
  end
  
end
