require 'test_helper'

class FrontendSearchFilterAdvancedControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_filter_advanced" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        frontendSearchFilterAdvanced = _FrontendPages.frontend_search_filter_advanced( )
        _bxResponse = frontendSearchFilterAdvanced.instance_variable_get(:bxResponse)
        _fieldNames = frontendSearchFilterAdvanced.instance_variable_get(:fieldNames)
        assert_equals frontendSearchFilterAdvanced.instance_variable_get(:@exception ) , nil

        assert_equals _bxResponse.getHitFieldValues(_fieldNames).size , 10

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
