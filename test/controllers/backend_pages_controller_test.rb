require 'test_helper'

class BackendPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get backend_data_basic" do
    get backend_pages_backend_data_basic_url
    assert_response :success
  end

  test "should get backend_data_basic_xml" do
    get backend_pages_backend_data_basic_xml_url
    assert_response :success
  end

  test "should get backend_data_categories" do
    get backend_pages_backend_data_categories_url
    assert_response :success
  end

  test "should get backend_data_categories_xml" do
    get backend_pages_backend_data_categories_xml_url
    assert_response :success
  end

  test "should get backend_data_customers" do
    get backend_pages_backend_data_customers_url
    assert_response :success
  end

  test "should get backend_data_debug_xml" do
    get backend_pages_backend_data_debug_xml_url
    assert_response :success
  end

  test "should get backend_data_full_export" do
    get backend_pages_backend_data_full_export_url
    assert_response :success
  end

  test "should get backend_data_init" do
    get backend_pages_backend_data_init_url
    assert_response :success
  end

  test "should get backend_data_resource" do
    get backend_pages_backend_data_resource_url
    assert_response :success
  end

  test "should get backend_data_resource_xml" do
    get backend_pages_backend_data_resource_xml_url
    assert_response :success
  end

  test "should get backend_data_split_field_values" do
    get backend_pages_backend_data_split_field_values_url
    assert_response :success
  end

  test "should get backend_data_transactions" do
    get backend_pages_backend_data_transactions_url
    assert_response :success
  end

end
