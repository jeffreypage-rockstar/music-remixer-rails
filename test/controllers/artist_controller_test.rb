require 'test_helper'

class ArtistControllerTest < ActionController::TestCase
  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get dashboard" do
    get :dashboard
    assert_response :success
  end

  test "should get music" do
    get :music
    assert_response :success
  end

  test "should get connect" do
    get :connect
    assert_response :success
  end

end
