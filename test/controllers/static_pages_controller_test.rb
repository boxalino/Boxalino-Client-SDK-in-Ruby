require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get backend_data_basic" do
    get static_pages_backend_data_basic_url
    assert_response :success
  end

end
