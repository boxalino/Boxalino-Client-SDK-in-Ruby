require 'test_helper'

class FrontendSearchFacetCategoryControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_facet_category" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchFacetCategoryController.new

        _hitIds = ["41", "1940", "1065", "1151", "1241", "1321", "1385", "1401", "1609", "1801"]

        #testing the result of the frontend search basic case
        frontendSearchFacetCategory = _FrontendPages.frontend_search_facet_category(@account, @password , @exception , bxHost, request)

        _bxResponse= _FrontendPages.bxResponse

        # assert_nil _FrontendPages.exception
        assert_equal  _bxResponse.getHitIds() , _hitIds


      end

  end

end
