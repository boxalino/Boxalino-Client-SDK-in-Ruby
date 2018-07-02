require 'test_helper'

class FrontendSearchAutocompleteBasicControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_autocomplete_basic" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendSearchAutocompleteBasicController.new
        frontendSearchAutoCompleteBasic = _FrontendPages.frontend_search_autocomplete_basic(@account, @password , @exception , bxHost , request)

        @textualSuggestions = ['ida workout parachute pant', 'jade yoga jacket', 'push it messenger bag']

        _bxAutocompleteResponse = _FrontendPages.bxAutocompleteResponse
        _bxAutocompleteResponse.getTextualSuggestions()
        assert_nil (_FrontendPages.exception )
        assert_equal _bxAutocompleteResponse.getTextualSuggestions(), @textualSuggestions

      end

  end

end
