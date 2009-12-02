module Authentication
  
  # Surface the helpers to controllers that include this module.
  def self.included(controller)
    controller.send :helper_method, :current_user, :admin? 
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def admin?
    current_user && current_user.is_admin? 
  end
  
  def admin_required
    return if admin?
      
    respond_to do |format| 
      format.html do
        save_location
        redirect_to new_session_url
      end
      format.any(:json, :xml) do
        if user = authenticate_from_basic_auth
          session[:user_id] = user.id
        else
          request_http_basic_authentication 'Web Password'
        end
      end
    end 
  end
  
  def authenticate_from_basic_auth
    authenticate_with_http_basic do |login, password|
      User.authenticate(login, password)
    end
  end
  
  # Save the URI of the current request in the session.
  #
  # Return to this location by calling #redirect_back_or_default.
  def save_location
    session[:return_to] = request.request_uri
  end

  # Redirect to the URI stored by the most recent save_location 
  # call or to the supplied default.  Set an appropriately modified
  # after_filter :save_location, :only => [:index, :new, :show, :edit]
  # for any controller you want to be bounce-backable.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end