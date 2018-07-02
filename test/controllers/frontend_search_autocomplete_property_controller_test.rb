require 'test_helper'

class FrontendSearchAutocompletePropertyControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_autocomplete_property" do
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      request = ActionDispatch::Request.new({})
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendSearchAutocompletePropertyController.new
        frontendSearchAutoCompleteProperty = _FrontendPages.frontend_search_autocomplete_property(@account, @password , @exception , bxHost, request)


        _bxAutocompleteResponse = _FrontendPages.bxAutocompleteResponse

        _property = _FrontendPages.property

        _propertyHitValues = _bxAutocompleteResponse.getPropertyHitValues(_property)


        assert_nil (_FrontendPages.exception )

      end

  end

end
