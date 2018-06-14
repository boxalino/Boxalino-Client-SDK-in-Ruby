require 'test_helper'

class FrontendSearchBasicControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_basic" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)


        _hitIds = [41, 1940, 1065, 1151, 1241, 1321, 1385, 1401, 1609, 1801]
        _queryText = "women"

        #testing the result of the frontend search basic case
        frontendSearchBasic = _FrontendPages.frontend_search_basic( _queryText)
        _bxResponse = frontendSearchBasic.instance_variable_get(:bxResponse)

        assert_equals frontendSearchBasic.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitIds(), _hitIds


        #testing the result of the frontend search basic case with semantic filtering blue => products_color=Blue
        _queryText2 = "blue"
        frontendSearchBasic2 = _FrontendPages.frontend_search_basic(_queryText2)

        _bxResponse2 = frontendSearchBasic2.instance_variable_get(:bxResponse)
        assert_equals frontendSearchBasic2.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse2.getTotalHitCount(), 77

        #testing the result of the frontend search basic case with semantic filtering forcing zero results pink => products_color=Pink

        _queryText3 = "pink"
        frontendSearchBasic3 = _FrontendPages.frontend_search_basic(_queryText3)

        _bxResponse3 = frontendSearchBasic3.instance_variable_get(:bxResponse)
        assert_equals frontendSearchBasic3.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse3.getTotalHitCount(), 0

        #testing the result of the frontend search basic case with semantic filtering setting a filter on a specific product only if the search shows zero results (this one should not do it because workout shows results)

        _queryText4 = "workout"
        frontendSearchBasic4 = _FrontendPages.frontend_search_basic(_queryText4)

        _bxResponse4 = frontendSearchBasic4.instance_variable_get(:bxResponse)
        assert_equals frontendSearchBasic4.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse4.getTotalHitCount(), 28

        #testing the result of the frontend search basic case with semantic filtering setting a filter on a specific product only if the search shows zero results (this one should do it because workoutoup shows no results)
        _queryText5 = "workoutoup"
        frontendSearchBasic5 = _FrontendPages.frontend_search_basic(_queryText5)

        _bxResponse5 = frontendSearchBasic5.instance_variable_get(:bxResponse)
        assert_equals frontendSearchBasic5.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse5.getTotalHitCount(), 1

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
