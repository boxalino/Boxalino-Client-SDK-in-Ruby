require 'test_helper'

class FrontendSearchDebugRequestControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_debug_request" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        _hitIds = [41, 1940, 1065, 1151, 1241, 1321, 1385, 1401, 1609, 1801]

        #testing the result of the frontend search basic case
        frontendSearchDebugRequest = _FrontendPages.frontend_search_debug_request( )
        _bxClient = frontendSearchDebugRequest.instance_variable_get(:bxClient)

        assert_equals frontendSearchDebugRequest.instance_variable_get(:@exception ) , nil
        assert  _bxClient.getThriftChoiceRequest().kind_of? ChoiceRequest


      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
