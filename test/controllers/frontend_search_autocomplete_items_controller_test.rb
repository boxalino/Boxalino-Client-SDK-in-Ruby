require 'test_helper'

class FrontendSearchAutocompleteItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_autocomplete_items" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendSearchAutoCompleteItems = _FrontendPages.frontend_search_autocomplete_items()

        _textualSuggestions = ['ida workout parachute pant', 'jade yoga jacket', 'push it messenger bag']


        _bxAutocompleteResponse = frontendSearchAutoCompleteItems.instance_variable_get(:bxAutocompleteResponse)
        _fieldNames = frontendSearchAutoCompleteItems.instance_variable_get(:fieldNames)
        _itemSuggestions = _bxAutocompleteResponse.getBxSearchResponse().getHitFieldValues(_fieldNames)


        assert_equals frontendSearchAutoCompleteItems.instance_variable_get(:@exception ) , nil
        assert_equals _itemSuggestions.size, 5


        assert_equals _bxAutocompleteResponse.getTextualSuggestions(), _textualSuggestions

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
