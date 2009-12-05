require 'test_helper'

class MentionsControllerTest < ActionController::TestCase
  
  test "index should redirect to login when non-admin requests it" do
    get :index
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "index should render page" do
    login_admin
    get :index
    assert_response :success
    assert_not_nil assigns(:mentions)
    assert_template 'mentions/index'
  end

  test "show should redirect to login when non-admin requests it" do
    get :show, :id => mentions(:one).to_param
    assert_response :redirect
    assert_redirected_to new_session_url
  end

  test "show should render page" do
    login_admin
    get :show, :id => mentions(:one).to_param
    assert_response :success
    assert_template 'mentions/show'
  end

  test "edit should redirect to login when non-admin requests it" do
    get :edit, :id => mentions(:one).to_param
    assert_response :redirect
    assert_redirected_to new_session_url
  end

  test "edit should render page" do
    login_admin
    get :edit, :id => mentions(:one).to_param
    assert_equal mentions(:one), assigns(:mention)
    assert_response :success
    assert_template 'mentions/edit'
  end

  test "update should redirect to login when non-admin requests it" do
    put :update, :id => mentions(:one).to_param, :mention => { }
    assert_response :redirect
    assert_redirected_to new_session_url
  end

  test "update should change mention and redirect" do
    login_admin
    put :update, :id => mentions(:one).to_param, 
                 :mention => { :text => "new text" }
    assert_equal "new text", mentions(:one, :reload).text
    assert_redirected_to mention_path(assigns(:mention))
  end

  test "parse should redirect to login when non-admin requests it" do
    post :parse, :id => mentions(:pending).to_param
    assert_response :redirect
    assert_redirected_to new_session_url
  end

  test "parse valid mention should parse mention and redirect" do
    login_admin
    post :parse, :id => mentions(:pending).to_param
    assert mentions(:pending, :reload).was_parsed
    assert_redirected_to mention_path(assigns(:mention))
  end

  test "parse invalid mention should not parse and show mention" do
    mentions(:pending).text = "missing hashtag and url"
    mentions(:pending).save
    
    login_admin
    post :parse, :id => mentions(:pending).to_param
    assert !mentions(:pending, :reload).was_parsed
    assert_response :success
    assert_template 'mentions/show'
  end

  test "destroy should redirect to login when non-admin requests it" do
    delete :destroy, :id => mentions(:one).to_param
    assert_response :redirect
    assert_redirected_to new_session_url
  end

  test "destroy should remove mention and redirect" do
    login_admin
    assert_difference('Mention.count', -1) do
      delete :destroy, :id => mentions(:one).to_param
    end
    assert_redirected_to mentions_path
  end
  
end
