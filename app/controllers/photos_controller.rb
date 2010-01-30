class PhotosController < ApplicationController
    
  before_filter :admin_required, :except => [:index]
  
  def index
    @assignment = Assignment.published.find_by_position(params[:id])
    unless @assignment
      redirect_to assignments_url
      return
    end
    @photos = @assignment.photos.with_photog.paginate(:page => params[:page], :per_page => 30)
    
    respond_to do |format|
      format.html { render :template => "assignments/show" }
      format.xml  { render :xml  => @photos }
      format.json { render :json => @photos }
    end
  end
  
  def destroy
    @photo = Photo.find_by_id(params[:id])
    @photog = @photo.photog
    @photo.destroy

    respond_to do |format|
      flash[:notice] = 'Photo was successfully deleted.'
      format.html { redirect_to @photog }
      format.any(:xml, :json)  { head :ok }
    end
  end
  
  def regenerate
    @photo = Photo.find(params[:id])
    @photog = @photo.photog
    @photo.update_image_urls
    if @photo.save
      flash[:notice] = "Successfully regenerated thumbnail."
      redirect_to @photog
    else  
      flash[:error] = "Unable to save photo."
      redirect_to @photog
    end
  rescue Photo::ThumbRetrievalError => e
    flash[:error] = "Photo error: #{e.message}"
    redirect_to @photog
  end

end
