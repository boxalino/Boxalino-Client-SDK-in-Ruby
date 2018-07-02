require 'test_helper'

class FrontendSearchAutocompleteItemsBundledControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_autocomplete_items_bundled" do
      @account = "boxalino_automated_tests2"
      @password = "boxalino_automated_tests2"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendSearchAutocompleteItemsBundledController.new
        frontendSearchAutoCompleteItemsBundled = _FrontendPages.frontend_search_autocomplete_items_bundled(@account, @password , @exception , bxHost , request)

        @firstTextualSuggestions = ['ida workout parachute pant', 'jade yoga jacket', 'push it messenger bag']
        @secondTextualSuggestions = ['argus all weather tank', 'jupiter all weather trainer', 'livingston all purpose tight']


        _bxAutocompleteResponses = _FrontendPages.bxAutocompleteResponses
        _fieldNames = _FrontendPages.fieldNames
        assert_nil (_FrontendPages.exception )
        assert_equal _bxAutocompleteResponses.size, 2

        #first response
        # assert_equal _bxAutocompleteResponses[0].getTextualSuggestions(), @firstTextualSuggestions
        #global ids
        assert_equal _bxAutocompleteResponses[0].getBxSearchResponse().getHitFieldValues(_fieldNames).keys, ["115", "131", "227", "355", "611"]

        #second response
        assert_equal _bxAutocompleteResponses[1].getTextualSuggestions(), @secondTextualSuggestions
        #global ids
        assert_equal _bxAutocompleteResponses[1].getBxSearchResponse().getHitFieldValues(_fieldNames).keys, ["1545"]

      end

  end

end
