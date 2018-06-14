require 'test_helper'

class FrontendSearchFacetControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_facet" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        #testing the result of the frontend search basic case
        frontendSearchFacet = _FrontendPages.frontend_search_facet( )
        _bxResponse = frontendSearchFacet.instance_variable_get(:bxResponse)
        _facetField = frontendSearchFacet.instance_variable_get(:facetField)
        assert_equals frontendSearchFacet.instance_variable_get(:@exception ) , nil

        assert_equals _bxResponse.getHitFieldValues([_facetField])[41] , { 'products_color'=>['Black' , 'Gray' , 'Yellow'] }
        assert_equals _bxResponse.getHitFieldValues([_facetField])[1940] , { 'products_color'=>['Gray', 'Orange', 'Yellow'] }

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
