class AssignmentsController < ApplicationController
  
  before_filter :admin_required, :except => [:index, :show]
  before_filter :set_cache_control, :only => [:index, :show]
  
  def index
    @assignments = Assignment.published_with_photos.paginate(:page => params[:page], :per_page => 30)
  
    respond_to do |format|
      format.html
      format.rss
      format.xml  { render :xml  => @assignments }
      format.json { render :json => @assignments }
    end
  end

  def show
    @assignment = Assignment.published.find_by_position(params[:id])
    unless @assignment
      redirect_to assignments_url
      return
    end
    
    all_photos = @assignment.photos.with_photog
    
    @photo_count = all_photos.size
    @photos = all_photos.paginate(:page => params[:page], :per_page => 30)
    
    respond_to do |format|
      format.html
      format.xml  { render :xml  => @assignment }
      format.json { render :json => @assignment }
    end
  rescue ActiveRecord::StatementInvalid
    redirect_to assignments_url
  end

# ADMIN ONLY

  def upcoming
    @first_upcoming_position = Assignment.first_upcoming_position
    @assignments = Assignment.upcoming

    respond_to do |format|
      format.html
      format.rss
      format.xml  { render :xml  => @assignments }
      format.json { render :json => @assignments }
    end
  end

  def new
    @assignment = Assignment.new
    
    respond_to do |format|
      format.html
      format.xml  { render :xml  => @assignment }
      format.json { render :json => @assignment }
    end
  end

  def edit
    @assignment = Assignment.find_by_position(params[:id])
  end

  def create
    @assignment = Assignment.new(params[:assignment])

    respond_to do |format|
      if @assignment.save
        flash[:notice] = 'Assignment was successfully created.'
        format.html { redirect_to upcoming_assignments_url }
        format.xml  { render :xml  => @assignment, :status => :created, :location => @assignment }
        format.json { render :json => @assignment, :status => :created, :location => @assignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml  => @assignment.errors, :status => :unprocessable_entity }
        format.json { render :json => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @assignment = Assignment.find_by_position(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        flash[:notice] = 'Assignment was successfully updated.'
        format.html { redirect_to upcoming_assignments_url }
        format.xml  { render :xml => @assignment }
        format.json { render :json => @assignment }        
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @assignment.errors, :status => :unprocessable_entity }
        format.json { render :json => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @assignment = Assignment.find_by_position(params[:id])
    @assignment.destroy

    respond_to do |format|
      flash[:notice] = 'Assignment was successfully deleted.'
      format.html { redirect_to(upcoming_assignments_url) }
      format.any(:xml, :json)  { head :ok }
    end
  end
  
  def reorder
    @assignment = Assignment.find_by_position(params[:id])
    @assignment.move(params[:direction])
    redirect_to upcoming_assignments_url
  end
  
end
