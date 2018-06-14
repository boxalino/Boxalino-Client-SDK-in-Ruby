require 'test_helper'

class FrontendSearchRequestContextParametersControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_request_context_parameters" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendSearchRequestContextParametersController.new(@account, @password , @exception , bxHost)

        frontendSearchRequestContextParameters = _FrontendPages.frontend_search_request_context_parameters( )
        assert_equals frontendSearchRequestContextParameters.instance_variable_get(:@exception ) , nil

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
