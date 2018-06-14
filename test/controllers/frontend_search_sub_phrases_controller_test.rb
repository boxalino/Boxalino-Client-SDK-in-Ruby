require 'test_helper'

class FrontendSearchSubPhrasesControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_sub_phrases" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        frontendSearchSubPhrases = _FrontendPages.frontend_search_sub_phrases( )

        _bxResponse = frontendSearchSubPhrases.instance_variable_get(:bxResponse)

        assert_equals frontendSearchSubPhrases.instance_variable_get(:@exception ) , nil
        assert _bxResponse.areThereSubPhrases()
        assert_equals _bxResponse.getSubPhrasesQueries().size , 2

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
