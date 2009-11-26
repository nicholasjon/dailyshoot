class PhotosController < ApplicationController
    
  def index
    @assignment = Assignment.find(params[:assignment_id])
    @photos = @assignment.photos.with_photog
    
    respond_to do |format|
      format.html
      format.xml  { render :xml  => @photos }
      format.json { render :json => @photos }
    end
  end

end
