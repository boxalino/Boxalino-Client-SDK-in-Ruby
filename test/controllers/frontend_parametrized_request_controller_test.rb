require 'test_helper'

class FrontendParametrizedRequestControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_parametrized_request" do
    get frontend_parametrized_request_frontend_parametrized_request_url
    assert_response :success
  end

end
