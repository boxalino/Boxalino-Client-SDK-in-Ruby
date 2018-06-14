require 'test_helper'

class FrontendSearchReturnFieldsControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_return_fields" do
    begin
      @account = "boxalino_automated_tests"
      @password = "boxalino_automated_tests"
      @exception = nil
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        frontendSearchReturnFields = _FrontendPages.frontend_search_return_fields( )

        _bxResponse = frontendSearchReturnFields.instance_variable_get(:bxResponse)
        _fieldNames = frontendSearchReturnFields.instance_variable_get(:fieldNames)

        assert_equals frontendSearchReturnFields.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitFieldValues(_fieldNames)[41][_fieldNames[0]] , ['Black' , 'Gray' , 'Yellow']
        assert_equals _bxResponse.getHitFieldValues(_fieldNames)[1940][_fieldNames[0]] , ['Gray', 'Orange', 'Yellow']

      end
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      puts "Exception"
      end
    end
  end

end
