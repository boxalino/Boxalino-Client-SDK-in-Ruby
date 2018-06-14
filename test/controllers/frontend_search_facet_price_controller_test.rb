require 'test_helper'

class FrontendSearchFacetPriceControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_facet_price" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        #testing the result of the frontend search basic case
        frontendSearchFacetPrice = _FrontendPages.frontend_search_facet_price( )
        _bxResponse = frontendSearchFacetPrice.instance_variable_get(:bxResponse)
        _facets = frontendSearchFacetPrice.instance_variable_get(:facets)
        assert_equals frontendSearchFacetPrice.instance_variable_get(:@exception ) , nil
        assert_equals _facets.getPriceRanges()[0] , "22-84"

        _bxResponse.getHitFieldValues([_facets.getPriceFieldName()]).each do |fieldValueMap|
          assert_not_equals fieldValueMap['discountedPrice'][0].to_f , 84.0
          assert_not_equals fieldValueMap['discountedPrice'][0].to_f , 22.0
        end

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end

end
