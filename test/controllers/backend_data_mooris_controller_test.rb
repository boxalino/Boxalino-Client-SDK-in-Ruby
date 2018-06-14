require 'test_helper'

class BackendDataMoorisControllerTest < ActionDispatch::IntegrationTest
  test "should get backend_data_mooris" do
    get backend_data_mooris_backend_data_mooris_url
    assert_response :success
  end

end
