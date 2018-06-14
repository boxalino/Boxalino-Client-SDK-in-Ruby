require 'test_helper'

class FrontendSearchAutocompletePropertyControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_autocomplete_property" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendSearchAutoCompleteProperty = _FrontendPages.frontend_search_autocomplete_property()


        _bxAutocompleteResponse = frontendSearchAutoCompleteProperty.instance_variable_get(:bxAutocompleteResponse)

        _property = frontendSearchAutoCompleteProperty.instance_variable_get(:property)

        _propertyHitValues = _bxAutocompleteResponse.getPropertyHitValues(_property)


        assert_equals frontendSearchAutoCompleteProperty.instance_variable_get(:@exception ) , nil

        assert_equals _propertyHitValues.size, 2


        assert_equals _propertyHitfrontend_search_basicValues[0], 'Hoodies &amp; Sweatshirts'

        assert_equals _propertyHitValues[1],  'Bras &amp; Tanks'

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
