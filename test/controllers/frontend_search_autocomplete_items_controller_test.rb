require 'test_helper'

class FrontendSearchAutocompleteItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_autocomplete_items" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendSearchAutocompleteItemsController.new
        frontendSearchAutoCompleteItems = _FrontendPages.frontend_search_autocomplete_items(@account, @password , @exception , bxHost , request)

        _textualSuggestions = ['ida workout parachute pant', 'jade yoga jacket', 'push it messenger bag']

        _bxAutocompleteResponse = _FrontendPages.bxAutocompleteResponse
        _fieldNames = _FrontendPages.fieldNames

        _itemSuggestions = _bxAutocompleteResponse.getBxSearchResponse().getHitFieldValues(_fieldNames)


        assert_nil (_FrontendPages.exception )
        assert_equal _itemSuggestions.size, 5


        assert_equal _bxAutocompleteResponse.getTextualSuggestions(), _textualSuggestions

      end

  end

end
