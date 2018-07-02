require 'test_helper'

class FrontendSearchBasicControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_basic" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|




        _hitIds = ["41", "1940", "1065", "1151", "1241", "1321", "1385", "1401", "1609", "1801"]
        _queryText = "women"

        #testing the result of the frontend search basic case
        _FrontendPages = FrontendSearchBasicController.new
        frontendSearchBasic = _FrontendPages.frontend_search_basic(@account, @password , @exception , bxHost, request, _queryText)
        _bxResponse = _FrontendPages.bxResponse

        assert_nil (_FrontendPages.exception )
        assert_equal _bxResponse.getHitIds(), _hitIds


        #testing the result of the frontend search basic case with semantic filtering blue => products_color=Blue
        _queryText2 = "blue"
        _FrontendPages2 = FrontendSearchBasicController.new
        frontendSearchBasic2 = _FrontendPages2.frontend_search_basic(@account, @password , @exception , bxHost, request, _queryText2)

        _bxResponse2 = _FrontendPages2.bxResponse
        assert_nil (_FrontendPages2.exception )
        assert_equal _bxResponse2.getTotalHitCount(), 79

        #testing the result of the frontend search basic case with semantic filtering forcing zero results pink => products_color=Pink

        _queryText3 = "pink"
        _FrontendPages3 = FrontendSearchBasicController.new
        frontendSearchBasic3 = _FrontendPages3.frontend_search_basic(@account, @password , @exception , bxHost, request, _queryText3)

        _bxResponse3 = _FrontendPages3.bxResponse
        assert_nil (_FrontendPages3.exception )
        assert_equal _bxResponse3.getTotalHitCount(), 8

        #testing the result of the frontend search basic case with semantic filtering setting a filter on a specific product only if the search shows zero results (this one should not do it because workout shows results)

        _queryText4 = "workout"
        _FrontendPages4 = FrontendSearchBasicController.new
        frontendSearchBasic4 = _FrontendPages4.frontend_search_basic(@account, @password , @exception , bxHost, request, _queryText4)

        _bxResponse4 = _FrontendPages4.bxResponse
        assert_nil (_FrontendPages4.exception )
        assert_equal _bxResponse4.getTotalHitCount(), 28

        #testing the result of the frontend search basic case with semantic filtering setting a filter on a specific product only if the search shows zero results (this one should do it because workoutoup shows no results)
        _queryText5 = "workoutoup"
        _FrontendPages5 = FrontendSearchBasicController.new
        frontendSearchBasic5 = _FrontendPages5.frontend_search_basic(@account, @password , @exception , bxHost, request, _queryText5)
        test = _FrontendPages5.exception
        _bxResponse5 = _FrontendPages5.bxResponse
        assert_nil (_FrontendPages5.exception )
        assert_equal _bxResponse5.getTotalHitCount(), 0

      end

  end

end
