require 'test_helper'

class FrontendSearchSortFieldControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_sort_field" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        frontendSearchSortField = _FrontendPages.frontend_search_sort_field( )

        _bxResponse = frontendSearchSortField.instance_variable_get(:bxResponse)
        _sortField = frontendSearchSortField.instance_variable_get(:sortField)

        assert_equals frontendSearchSortField.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitFieldValues(_sortField).keys , [1940,41]

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
