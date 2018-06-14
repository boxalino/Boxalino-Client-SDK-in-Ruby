require 'test_helper'

class FrontendSearchAutocompleteItemsBundledControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_autocomplete_items_bundled" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendSearchAutoCompleteItemsBundled = _FrontendPages.frontend_search_autocomplete_items_bundled()

        @firstTextualSuggestions = ['ida workout parachute pant', 'jade yoga jacket', 'push it messenger bag']
        @secondTextualSuggestions = ['argus all weather tank', 'jupiter all weather trainer', 'livingston all purpose tight']


        _bxAutocompleteResponses = frontendSearchAutoCompleteItemsBundled.instance_variable_get(:bxAutocompleteResponses)
        _fieldNames = frontendSearchAutoCompleteItemsBundled.instance_variable_get(:fieldNames)
        assert_equals frontendSearchAutoCompleteItemsBundled.instance_variable_get(:@exception ) , nil
        assert_equals _bxAutocompleteResponses.size, 2

        #first response
        assert_equals _bxAutocompleteResponses[0].getTextualSuggestions(), @firstTextualSuggestions
        #global ids
        assert_equals _bxAutocompleteResponses[0].getBxSearchResponse().getHitFieldValues(_fieldNames).keys, [115, 131, 227, 355, 611]

        #second response
        assert_equals _bxAutocompleteResponses[1].getTextualSuggestions(), @secondTextualSuggestions
        #global ids
        assert_equals _bxAutocompleteResponses[1].getBxSearchResponse().getHitFieldValues(_fieldNames).keys, [1545]

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
