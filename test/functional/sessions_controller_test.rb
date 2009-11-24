require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  test "new should render login page" do
    get :new
    assert_response :success
    assert_template "sessions/new"
  end

  test "create should redirect to login page for invalid login" do
    post :create, :login => "invalid", :password => "password"
    assert_redirected_to new_session_url
    assert @response.session[:user_id].blank?
  end

  test "create should redirect to login page for invalid password" do
    post :create, :login => "user", :password => "invalid"
    assert_redirected_to new_session_url
    assert @response.session[:user_id].blank?
  end

  test "destroy should remove user_id from session" do
    login_admin

    get :destroy
    assert_redirected_to new_session_url
    assert @response.session[:user_id].blank?
  end
end
