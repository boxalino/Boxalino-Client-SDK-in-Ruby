require 'test_helper'

class FrontendRecommendationsSimilarControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_recommendations_similar" do
    @account = "boxalino_automated_tests"
    @password = "boxalino_automated_tests"
    @exception = nil
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendRecommendationsSimilar = _FrontendPages.frontend_recommendations_similar()

        @hitIds = (1..10).to_a

        _bxResponse = frontendRecommendationsSimilar.instance_variable_get(:bxResponse)
        assert_equals frontendRecommendationsSimilar.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitIds(), @hitIds

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
        puts "Exception"
      end
    end
  end

end
