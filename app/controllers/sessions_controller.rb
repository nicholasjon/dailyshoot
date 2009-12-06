class SessionsController < ApplicationController
  
  skip_before_filter :admin_required
  ssl_required :new, :create
  
  def new
  end
  
  def create
    user = User.authenticate(params[:login], params[:password])
  
    respond_to do |format|
      if user
        format.html do 
          session[:user_id] = user.id
          redirect_back_or_default root_url 
        end
        format.any(:xml, :json) { head :ok }
      else
        format.html do 
          flash[:error] = "Invalid login or password."
          redirect_to new_session_url
        end
        format.any(:xml, :json) do
          request_http_basic_authentication 'Web Password'
        end
      end
    end
  end
  
  def destroy
    flash[:notice] = "You've been logged out."
    session[:user_id] = nil
    redirect_to new_session_url
  end
  
end
