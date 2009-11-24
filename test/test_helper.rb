ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
  
  def login_admin
    login! :admin
  end
  
private

  def login!(login)
    @user = Symbol === login ? users(login) : login
    @request.session[:user_id] = @user.id
  end

  def logout!
    @request.session[:user_id] = nil
  end

  def api_login!(login, password)
    logout!
    @user = Symbol === login ? users(login) : login
    token = Base64.encode64("#{@user.user_name}:#{password}")
    @request.env['HTTP_AUTHORIZATION'] = "Basic: #{token}"
  end

end
