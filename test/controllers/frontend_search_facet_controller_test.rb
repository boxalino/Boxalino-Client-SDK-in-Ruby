require 'test_helper'

class FrontendSearchFacetControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_facet" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchFacetController.new

        #testing the result of the frontend search basic case
        frontendSearchFacet = _FrontendPages.frontend_search_facet(@account, @password , @exception , bxHost, request)

        _bxResponse = _FrontendPages.bxResponse
        _facetField = _FrontendPages.facetField
        # assert_nil (_FrontendPages.exception )

        assert_equal _bxResponse.getHitFieldValues([_facetField])["41"] , { 'products_color'=>['Black' , 'Gray' , 'Yellow'] }
        assert_equal _bxResponse.getHitFieldValues([_facetField])["1940"] , { 'products_color'=>['Gray', 'Orange', 'Yellow'] }

      end

  end

end
