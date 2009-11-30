require 'test_helper'

class SuggestionsControllerTest < ActionController::TestCase

  test "index should redirect to login when non-admin requests it" do
    get :index
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "index should load suggestions and render page" do
    login_admin
    get :index
    assert_not_nil assigns(:suggestions)
    assert_response :success
    assert_template "suggestions/index"
  end

  test "show should redirect to login when non-admin requests it" do
    get :show, :id => suggestions(:one)
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "show should load suggestion and render page" do
    login_admin
    get :show, :id => suggestions(:one)
    assert_equal suggestions(:one), assigns(:suggestion)
    assert_response :success
    assert_template "suggestions/show"
  end

  test "new should render page" do
    get :new
    assert_response :success
    assert_template "suggestions/new"
  end
  
  test "create should create suggestion and redirect" do
    assert_difference('Suggestion.count') do
      post :create, 
           :suggestion => {:who => "@clarkware", 
                           :what => "Here's an idea..."}
    end
    assert_redirected_to(new_suggestion_path)
  end

  test "destroy should redirect to login when non-admin requests it" do
    delete :destroy, :id => suggestions(:one)
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "destroy should remove suggestion and redirect" do
    login_admin
    assert_difference('Suggestion.count', -1) do
      delete :destroy, :id => suggestions(:one)
    end

    assert_redirected_to suggestions_path
  end
  
end
