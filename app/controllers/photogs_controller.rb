class PhotogsController < ApplicationController
    
  def index
    @photogs = Photog.all(:order => 'screen_name')
    
    respond_to do |format|
      format.html
      format.xml  { render :xml  => @photogs }
      format.json { render :json => @photogs }
    end
  end
  
  def show
    @photog = Photog.find_by_screen_name(params[:id])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml  => @photog }
      format.json { render :json => @photog }
    end
  end
  

end
