class PhotogsController < ApplicationController
    
  def index
    response.headers['Cache-Control'] = 'public, max-age=600'
    @photogs = Photog.all_by_photos_count
    @photog_count = Photog.count
    @photos_count = Photo.count 
    
    respond_to do |format|
      format.html
      format.xml  { render :xml  => @photogs }
      format.json { render :json => @photogs }
    end
  end
  
  def show
    response.headers['Cache-Control'] = 'public, max-age=600'
    @photog = Photog.find_by_screen_name(params[:id])
    
    unless @photog
      redirect_to(photogs_url) 
      return
    end
      
    respond_to do |format|
      format.html
      format.xml  { render :xml  => @photog }
      format.json { render :json => @photog }
    end
  end
  

end
