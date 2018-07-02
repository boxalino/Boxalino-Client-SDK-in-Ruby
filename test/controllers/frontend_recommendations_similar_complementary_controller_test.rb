require 'test_helper'

class FrontendRecommendationsSimilarComplementaryControllerTest < ActionDispatch::IntegrationTest


  test "should get frontend_recommendations_similar_complementary" do
    begin
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendRecommendationsSimilarComplementaryController.new
        frontendRecommendationsSimilarComplementary = _FrontendPages.frontend_recommendations_similar_complementary(@account, @password , @exception, bxHost ,request)

        @complementaryIds = ("11".."20").to_a
        @similarIds = ("1".."10").to_a

        _bxResponse = _FrontendPages.bxResponse
        assert_nil (_FrontendPages.exception )
        assert_equal _bxResponse.getHitIds(_FrontendPages.choiceIdSimilar), @similarIds
        assert_equal _bxResponse.getHitIds(_FrontendPages.choiceIdComplementary), @complementaryIds

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts e
      end
    end
  end

end
