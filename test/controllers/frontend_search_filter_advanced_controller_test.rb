require 'test_helper'

class FrontendSearchFilterAdvancedControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_filter_advanced" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchFilterAdvancedController.new

        frontendSearchFilterAdvanced = _FrontendPages.frontend_search_filter_advanced(@account, @password , @exception , bxHost , request)
        _bxResponse = _FrontendPages.bxResponse
        _fieldNames = _FrontendPages.fieldNames
        assert_nil (_FrontendPages.exception )

        assert_equal _bxResponse.getHitFieldValues(_fieldNames).size , 10

      end

  end

end
