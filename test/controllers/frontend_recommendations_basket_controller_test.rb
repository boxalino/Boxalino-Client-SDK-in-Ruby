require 'test_helper'

class FrontendRecommendationsBasketControllerTest < ActionDispatch::IntegrationTest


  test "should get frontend_recommendations_basket" do

      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']


       request = ActionDispatch::Request.new({})
       @bxHosts.each do |bxHost|
        FrontendRecommendationsBasket =  FrontendRecommendationsBasketController.new
        frontendRecommendationsBasket = FrontendRecommendationsBasket.frontend_recommendations_basket(@account, @password , @exception, bxHost ,request)
        @hitIds = ("1".."10").to_a

        _bxResponse = FrontendRecommendationsBasket.bxResponse
        assert_nil (FrontendRecommendationsBasket.exception)
        assert_equal _bxResponse.getHitIds(), @hitIds

       end

  end

end
