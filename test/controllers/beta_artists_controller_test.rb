require 'test_helper'

class BetaArtistsControllerTest < ActionController::TestCase
  test "should get join" do
    get :join
    assert_response :success
  end

end
