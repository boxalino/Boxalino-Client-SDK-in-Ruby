require 'test_helper'

class FrontendSearchTwoPageControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_two_page" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendSearch2ndPage = _FrontendPages.frontend_search_2nd_page()

        @hitIds = [40, 41, 42, 44]

        _bxResponse = frontendSearch2ndPage.instance_variable_get(:bxResponse)
        assert_equals frontendSearch2ndPage.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitIds(), @hitIds

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
