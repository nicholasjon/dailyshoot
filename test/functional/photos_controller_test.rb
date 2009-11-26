require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  
  test "index should load photos and render page" do
    get :index, :assignment_id => assignments(:default).id
    assert_equal assignments(:default), assigns(:assignment)
    assert_not_nil assigns(:photos)
    assert_response :success
    assert_template "photos/index"
  end
  
  # === API tests ===

  test "index via API should return photos" do
    get :index, :assignment_id => assignments(:default).id, :format => "xml"
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert_equal 1, xml["photos"].length
  end
  
end
