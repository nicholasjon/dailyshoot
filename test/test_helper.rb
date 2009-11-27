ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require 'fakeweb'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
  
  def login_admin
    login! :admin
  end
  
  def fixture_file(filename)
    return '' if filename == ''
    file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
    File.read(file_path)
  end

  def twitter_url(url)
    url =~ /^http/ ? url : "http://twitter.com:80#{url}"
  end

  def stub_get(url, filename, status=nil)
    options = {:body => fixture_file(filename)}
    options.merge!({:status => status}) unless status.nil?

    FakeWeb.register_uri(:get, twitter_url(url), options)
  end

  def twitter_client
    httpauth = Twitter::HTTPAuth.new('username', 'password')
    Twitter::Base.new(httpauth)
  end
  
  def stub_mentions
    client = twitter_client
    stub_get('http://username:password@twitter.com:80/statuses/mentions.json', 'mentions.json')
    client.mentions
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
