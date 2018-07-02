require 'test_helper'

class FrontendSearchFilterControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_filter" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchFilterController.new

        frontendSearchFilter = _FrontendPages.frontend_search_filter(@account, @password , @exception , bxHost, request)
        _bxResponse = _FrontendPages.bxResponse
        assert_nil (_FrontendPages.exception )

        assert !_bxResponse.getHitIds().include?("41")
        assert !_bxResponse.getHitIds().include?("1940")

      end

  end

end
