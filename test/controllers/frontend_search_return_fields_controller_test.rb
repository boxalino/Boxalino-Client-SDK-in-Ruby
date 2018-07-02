require 'test_helper'

class FrontendSearchReturnFieldsControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_return_fields" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchReturnFieldsController.new

        frontendSearchReturnFields = _FrontendPages.frontend_search_return_fields(@account, @password , @exception , bxHost, request)

        _bxResponse = _FrontendPages.bxResponse
        _fieldNames = _FrontendPages.fieldNames

         assert_nil (_FrontendPages.exception )

      end

  end

end
