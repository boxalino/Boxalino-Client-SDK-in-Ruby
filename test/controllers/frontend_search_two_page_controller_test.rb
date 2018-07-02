require 'test_helper'

class FrontendSearchTwoPageControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_two_page" do
    @account = "boxalino_automated_tests"
    @password = "boxalino_automated_tests"
    @exception = nil
    @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
    request = ActionDispatch::Request.new({})
    @bxHosts.each do |bxHost|
      _FrontendPages = FrontendSearchTwoPageController.new
      frontendSearch2ndPage = _FrontendPages.frontend_search_two_page(@account, @password , @exception , bxHost , request)

      @hitIds = ["40", "41", "42", "44"]

      _bxResponse = _FrontendPages.bxResponse
      assert_nil (_FrontendPages.exception )
      assert_equal _bxResponse.getHitIds(), @hitIds

    end

  end

end
