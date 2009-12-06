require 'test_helper'

class PhotogsControllerTest < ActionController::TestCase
  
  test "index should load photogs and render page" do
    get :index
    assert_not_nil assigns(:photogs)
    assert_response :success
    assert_template "photogs/index"
  end
  
  test "show should load photog and render page" do
    get :show, :id => photogs(:joe).to_param
    assert_equal photogs(:joe), assigns(:photog)
    assert_response :success
    assert_template "photogs/show"
  end
  
  # === API tests ===

  test "index via API should return photogs" do
    get :index, :format => "xml"
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert_equal 1, xml["photogs"].length
  end
  
  test "show via API should return photog record" do
    get :show, :id => photogs(:joe).screen_name, :format => "xml"
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert_equal photogs(:joe).id, xml["photog"]["id"]
  end
  
end
