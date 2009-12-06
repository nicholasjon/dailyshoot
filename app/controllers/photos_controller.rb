class PhotosController < ApplicationController
    
  def index
    @assignment = Assignment.published.find_by_position(params[:id])
    unless @assignment
      redirect_to assignments_url
      return
    end
    @photos = @assignment.photos.with_photog
    
    respond_to do |format|
      format.html { render :template => "assignments/show" }
      format.xml  { render :xml  => @photos }
      format.json { render :json => @photos }
    end
  end

end
