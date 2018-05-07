require 'test_helper'

class BackendPagesControllerTest < ActionDispatch::IntegrationTest

  @account = "boxalino_automated_tests"
  @password = "boxalino_automated_tests"
  @exception = nil
  test "should get BackendDataFullExportTest" do
    begin
    _BackendPages = BackendPagesController.new(@account, @password , @exception)
    _BackendPages.backend_data_full_export()
    assert 'success'
    rescue Exception => e
      assert_raise do #Fails, no Exceptions are raised
      end
    end
  end

end
