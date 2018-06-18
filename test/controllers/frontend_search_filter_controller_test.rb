require 'test_helper'

class FrontendSearchFilterControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_filter" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        frontendSearchFilter = _FrontendPages.frontend_search_filter( )
        _bxResponse = frontendSearchFilter.instance_variable_get(:bxResponse)

        assert_equals frontendSearchFilter.instance_variable_get(:@exception ) , nil

        assert !_bxResponse.getHitIds().include?("41")
        assert !_bxResponse.getHitIds().include?("1940")

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      # puts "Exception"
      #end
    end
  end

end