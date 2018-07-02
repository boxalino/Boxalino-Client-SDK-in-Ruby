require 'test_helper'

class FrontendRecommendationsSimilarControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_recommendations_similar" do
    @account = "boxalino_automated_tests"
    @password = "boxalino_automated_tests"
    @exception = nil
    @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
    request = ActionDispatch::Request.new({})
    @bxHosts.each do |bxHost|
      _FrontendPages = FrontendRecommendationsSimilarController.new
      frontendRecommendationsSimilar = _FrontendPages.frontend_recommendations_similar(@account, @password , @exception , bxHost , request)

      @hitIds = ("1".."10").to_a

      _bxResponse = _FrontendPages.bxResponse
      assert_nil (_FrontendPages.exception )
      assert_equal _bxResponse.getHitIds(), @hitIds

    end

  end

end
