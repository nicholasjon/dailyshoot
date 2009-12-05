class AssignmentsController < ApplicationController
  
  before_filter :admin_required, :except => [:index, :show]
  
  def index
    response.headers['Cache-Control'] = 'public, max-age=600'
    @assignments = Assignment.published
  
    respond_to do |format|
      format.html
      format.rss
      format.xml  { render :xml  => @assignments }
      format.json { render :json => @assignments }
    end
  end

  def show
    response.headers['Cache-Control'] = 'public, max-age=600'
    @assignment = Assignment.published.find_by_position(params[:id])
    unless @assignment
      redirect_to assignments_url
      return
    end
    @photos = @assignment.photos.with_photog
    
    respond_to do |format|
      format.html
      format.xml  { render :xml  => @assignment }
      format.json { render :json => @assignment }
    end
  end

# ADMIN ONLY

  def upcoming
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
    @assignment.tag = "ds#{Assignment.last.position + 1}"
    @assignment.date = Date.tomorrow
    
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
  
end
