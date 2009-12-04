class PhotosController < ApplicationController
    
  def index
    @assignment = Assignment.find_by_position(params[:assignment_id])
    @photos = @assignment.photos.with_photog
    
    respond_to do |format|
      format.html { render :template => "assignments/show" }
      format.xml  { render :xml  => @photos }
      format.json { render :json => @photos }
    end
  end

end
