require 'test_helper'

class FrontendSearchAutocompleteBasicControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_autocomplete_basic" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendSearchAutoCompleteBasic = _FrontendPages.frontend_search_autocomplete_basic()

        @textualSuggestions = ['ida workout parachute pant', 'jade yoga jacket', 'push it messenger bag']

        _bxAutocompleteResponse = frontendSearchAutoCompleteBasic.instance_variable_get(:bxAutocompleteResponse)
        assert_equals frontendSearchAutoCompleteBasic.instance_variable_get(:@exception ) , nil
        assert_equals _bxAutocompleteResponse.getTextualSuggestions(), @textualSuggestions

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
