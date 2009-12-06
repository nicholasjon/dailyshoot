class ApplicationController < ActionController::Base
  include Authentication
  include SslRequirement
  
  helper :all
  
  protect_from_forgery

  filter_parameter_logging :password
  
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    
protected
  
  # default duration is 10 minutes. Might want to fine tune in filter call.
  def set_cache_control(duration=600)
    response.headers['Cache-Control'] = "public, max-age=#{duration}"
  end

  # Overridden from SslRequirement to allow local requests
  def ssl_required?
    return false if local_request? || RAILS_ENV == 'test'
    super
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => :not_found }
      format.any(:xml, :json)  { head :not_found }
    end
  end

end
