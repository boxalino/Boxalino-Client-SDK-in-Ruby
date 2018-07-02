require 'test_helper'

class FrontendSearchSubPhrasesControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_sub_phrases" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchSubPhrasesController.new

        frontendSearchSubPhrases = _FrontendPages.frontend_search_sub_phrases(@account, @password , @exception , bxHost, request)

        _bxResponse = _FrontendPages.bxResponse

        assert_nil (_FrontendPages.exception )
        assert _bxResponse.areThereSubPhrases()
        assert_equal _bxResponse.getSubPhrasesQueries().size , 2

      end

  end

end
