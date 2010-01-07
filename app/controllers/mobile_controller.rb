class MobileController < ApplicationController
  
  def index
    @assignments = Assignment.published
  end
  
  def assignment
    @assignment = Assignment.published.find_by_position(params[:id])
    unless @assignment
      redirect_to :action => :index
      return
    end

    render :layout => false
  end
  
end
