require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get def" do
    get :def
    assert_response :success
  end

  test "should get splash" do
    get :splash
    assert_response :success
  end

end
