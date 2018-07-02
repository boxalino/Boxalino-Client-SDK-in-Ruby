require 'test_helper'

class FrontendSearchRequestContextParametersControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_request_context_parameters" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchRequestContextParametersController.new
        frontendSearchRequestContextParameters = _FrontendPages.frontend_search_request_context_parameters(@account, @password , @exception , bxHost, request)
        assert_nil (_FrontendPages.exception )

      end

  end

end
