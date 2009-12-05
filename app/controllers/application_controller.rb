class ApplicationController < ActionController::Base
  include Authentication
  
  helper :all
  
  protect_from_forgery

  filter_parameter_logging :password
  
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    
protected

  def set_cache_control(duration=600)
    response.headers['Cache-Control'] = "public, max-age=#{duration}"
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => :not_found }
      format.any(:xml, :json)  { head :not_found }
    end
  end

end
