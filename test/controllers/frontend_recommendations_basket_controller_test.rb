require 'test_helper'

class FrontendRecommendationsBasketControllerTest < ActionDispatch::IntegrationTest


  test "should get frontend_recommendations_basket" do

    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception, bxHost)
        frontendRecommendationsBasket = _FrontendPages.frontend_recommendations_basket()
        @hitIds = (1..10).to_a

        _bxResponse = frontendRecommendationsBasket.instance_variable_get(:bxResponse)
        assert_equals frontendRecommendationsBasket.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitIds(), @hitIds

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
        puts "Exception"
      end
    end
  end

end
