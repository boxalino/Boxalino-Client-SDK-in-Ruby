require 'test_helper'

class FrontendSearchFacetPriceControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_facet_price" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchFacetPriceController.new

        #testing the result of the frontend search basic case
        frontendSearchFacetPrice = _FrontendPages.frontend_search_facet_price(@account, @password , @exception , bxHost , request)
        _bxResponse = _FrontendPages.bxResponse
        _facets = _FrontendPages.facets
         assert_nil (_FrontendPages.exception )
        assert_equal _facets.getPriceRanges()[0] , "22-84"

        _bxResponse.getHitFieldValues([_facets.getPriceFieldName()]).each do |fieldValueMap|
          assert_not_equal fieldValueMap[1]['discountedPrice'][0].to_f , 84.0
          assert_not_equal fieldValueMap[1]['discountedPrice'][0].to_f , 22.0
        end

      end

  end

end
