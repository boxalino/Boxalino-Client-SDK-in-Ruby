require 'test_helper'

class FrontendSearchSortFieldControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_sort_field" do
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchSortFieldController.new

        frontendSearchSortField = _FrontendPages.frontend_search_sort_field(@account, @password , @exception , bxHost, request)

        _bxResponse = _FrontendPages.bxResponse
        _sortField = _FrontendPages.sortField

        assert_nil (_FrontendPages.exception )

      end

  end

end
