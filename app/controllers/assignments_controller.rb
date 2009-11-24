class AssignmentsController < ApplicationController
  
  before_filter :admin_required, :except => [:index, :show]
  
  def index
    @assignments = Assignment.all

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @assignments }
      format.json { render :json => @assignments }
    end
  end

  def show
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @assignment }
      format.json { render :json => @assignment }
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
    @assignment = Assignment.find(params[:id])
  end

  def create
    @assignment = Assignment.new(params[:assignment])

    respond_to do |format|
      if @assignment.save
        flash[:notice] = 'Assignment was successfully created.'
        format.html { redirect_to @assignment }
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
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        flash[:notice] = 'Assignment was successfully updated.'
        format.html { redirect_to @assignment }
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
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to(assignments_url) }
      format.any(:xml, :json)  { head :ok }
    end
  end
  
end
