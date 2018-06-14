require 'test_helper'

class FrontendRecommendationsSimilarComplementaryControllerTest < ActionDispatch::IntegrationTest


  test "should get frontend_recommendations_similar_complementary" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendRecommendationsSimilarComplementary = _FrontendPages.frontend_recommendations_similar_complementary()

        @complementaryIds = (11..20).to_a
        @similarIds = (1..10).to_a

        choiceIdSimilar = frontendRecommendationsSimilarComplementary.instance_variable_get(:choiceIdSimilar)
        choiceIdComplementary = frontendRecommendationsSimilarComplementary.instance_variable_get(:choiceIdComplementary)
        _bxResponse = frontendRecommendationsSimilarComplementary.instance_variable_get(:bxResponse)
        assert_equals frontendRecommendationsSimilarComplementary.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitIds(choiceIdSimilar), @similarIds
        assert_equals _bxResponse.getHitIds(choiceIdComplementary), @complementaryIds

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
