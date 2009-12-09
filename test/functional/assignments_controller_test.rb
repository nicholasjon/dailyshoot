require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  
  test "index should load assignments and render page" do
    get :index
    assert_not_nil assigns(:assignments)
    assert_response :success
    assert_template "assignments/index"
  end
  
  test "show a published assignment should load assignment and render page" do
    get :show, :id => assignments(:ds10).to_param
    assert_equal assignments(:ds10), assigns(:assignment)
    assert_response :success
    assert_template "assignments/show"
  end

  test "show an unpublished assignment should redirect" do
    get :show, :id => assignments(:upcoming_1).to_param
    assert_response :redirect
    assert_redirected_to assignments_url
  end

  test "upcoming should redirect to login when non-admin requests it" do
    get :upcoming
    assert_response :redirect
    assert_redirected_to new_session_url
  end

  test "upcoming should load assignments and render page" do
    login_admin
    get :upcoming
    assert_not_nil assigns(:assignments)
    assert_response :success
    assert_template "assignments/upcoming"
  end

  test "new should redirect to login when non-admin requests it" do
    get :new
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "new should render page" do
    login_admin
    get :new
    assert_response :success
    assert_template "assignments/new"
  end

  test "create should redirect to login when non-admin requests it" do
    post :create, :assignment => { }
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "create should create assignment and redirect" do
    login_admin
    assert_difference('Assignment.count') do
      post :create, 
           :assignment => {:text => "Text", :tag => "tag", :date => Time.now}
    end
    assert_redirected_to upcoming_assignments_url
  end

  test "edit should redirect to login when non-admin requests it" do
    get :edit, :id => assignments(:ds10).to_param
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "edit should load assignment and render page" do
    login_admin
    get :edit, :id => assignments(:ds10).to_param
    assert_equal assignments(:ds10), assigns(:assignment)
    assert_response :success
    assert_template "assignments/edit"
  end

  test "update should redirect to login when non-admin requests it" do
    put :update, :id => assignments(:ds10).to_param
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "update should change assignment and redirect" do
    login_admin
    put :update, :id => assignments(:ds10).to_param, 
                 :assignment => { :text => "new text" }
    assert_equal "new text", assignments(:ds10, :reload).text
    assert_redirected_to upcoming_assignments_url
  end

  test "destroy should redirect to login when non-admin requests it" do
    delete :destroy, :id => assignments(:ds10).to_param
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "destroy should remove assignment and redirect" do
    login_admin
    assert_difference('Assignment.count', -1) do
      delete :destroy, :id => assignments(:ds10).to_param
    end

    assert_redirected_to upcoming_assignments_path
  end
  
  test "reorder should reorder assignment and redirect" do
    login_admin
    assert_equal 5, assignments(:upcoming_2).position
    get :reorder, :id => assignments(:upcoming_2).to_param, :direction => 'up'
    assert_equal 4, assignments(:upcoming_2, :reload).position
    assert_redirected_to upcoming_assignments_path
  end
  
  # === API tests ===

  test "index via API should return assignments" do
    get :index, :format => "xml"
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert_equal 3, xml["assignments"].length
  end
  
  test "show via API should return assignment record" do
    get :show, :id => assignments(:ds10).to_param, :format => "xml"
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert_equal assignments(:ds10).id, xml["assignment"]["id"]
  end
  
  test "new via API should return a template XML response" do
    login_admin
    get :new, :format => "xml"
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert xml["assignment"]
    assert !xml["assignment"]["id"]
  end
  
  test "create via API should return 422 with error messages when validations fail" do
    login_admin
    post :create, :assignment => { }, :format => "xml"
    assert_response :unprocessable_entity
    xml = Hash.from_xml(@response.body)
    assert xml["errors"].any?
  end
  
  test "create via API should create assignment and respond with 201" do
    login_admin
    assert_difference "Assignment.count" do
      post :create,
           :assignment => {:text => "Text", :tag => "tag", :date => Time.now},
           :format => "xml"
      assert_response :created
      assert @response.headers["Location"]
    end
  end
  
  test "update via API with validation errors should respond with 422" do
    login_admin
    put :update, :id => assignments(:ds10).to_param, 
                 :assignment => { :text => "" }, 
                 :format => "xml"
    assert_response :unprocessable_entity
    xml = Hash.from_xml(@response.body)
    assert xml["errors"].any?
  end

  test "update via API should update assignment and respond with 200" do
    login_admin
    put :update, :id => assignments(:ds10).to_param, 
                 :assignment => { :text => "new text" }, 
                 :format => "xml"
    assert_response :success  
    xml = Hash.from_xml(@response.body)    
    assert_equal "new text", xml["assignment"]["text"]
  end

  test "destroy via API should remove assignment and respond with 200" do
    login_admin
    assert_difference "Assignment.count", -1 do
      delete :destroy, :id => assignments(:ds10).to_param, :format => "xml"
      assert_response :success
    end
  end
  
end
