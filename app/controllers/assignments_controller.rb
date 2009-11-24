class AssignmentsController < ApplicationController
  
  before_filter :admin_required
  
  def index
    render :text => "Assignments"
  end
  
end