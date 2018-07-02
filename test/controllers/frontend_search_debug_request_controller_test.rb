require 'test_helper'

class FrontendSearchDebugRequestControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_debug_request" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchDebugRequestController.new

        _hitIds = ["41", "1940", "1065", "1151", "1241", "1321", "1385", "1401", "1609", "1801"]

        #testing the result of the frontend search basic case
        frontendSearchDebugRequest = _FrontendPages.frontend_search_debug_request(@account, @password , @exception , bxHost, request)
        _bxClient= _FrontendPages.bxClient

        assert_nil (_FrontendPages.exception )
        assert  _bxClient.getThriftChoiceRequest().kind_of? ChoiceRequest


      end

  end

end
