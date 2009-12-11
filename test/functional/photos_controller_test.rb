require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  
  test "index should load photos and render assignment show page" do
    get :index, :id => assignments(:ds10).to_param
    assert_equal assignments(:ds10), assigns(:assignment)
    assert_not_nil assigns(:photos)
    assert_response :success
    assert_template "assignments/show"
  end
  
  test "destroy should redirect to login when non-admin requests it" do
    delete :destroy, :id => photos(:bestcam).to_param
    assert_response :redirect
    assert_redirected_to new_session_url
  end

  test "destroy should remove photo and redirect" do
    login_admin
    assert_difference('Photo.count', -1) do
      delete :destroy, :id => photos(:bestcam).to_param
    end
    assert_redirected_to photog_url(photos(:bestcam).photog)
  end
  
  test "regenerate should redirect to login when non-admin requests it" do
    post :regenerate, :id => photos(:bestcam).to_param
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
  test "regenerate should update thumb url" do
    login_admin
    post :regenerate, :id => photos(:invalid_thumb).to_param
    assert_equal photos(:bestcam).thumb_url, assigns(:photo).thumb_url
    assert_redirected_to photog_url(photos(:invalid_thumb).photog)
  end
  
  # === API tests ===

  test "index via API should return photos" do
    get :index, :id => assignments(:ds10).to_param, :format => "xml"
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert_equal 1, xml["photos"].length
  end
  
  test "destroy via API should remove photo and respond with 200" do
    login_admin
    assert_difference "Photo.count", -1 do
      delete :destroy, :id => photos(:bestcam).to_param, :format => "xml"
      assert_response :success
    end
  end
  
end
