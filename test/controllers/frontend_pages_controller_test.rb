require 'test_helper'

class FrontendPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_parametrized_request" do
    get frontend_pages_frontend_parametrized_request_url
    assert_response :success
  end

  test "should get frontend_recommendations_basket" do
    get frontend_pages_frontend_recommendations_basket_url
    assert_response :success
  end

  test "should get frontend_recommendations_similar" do
    get frontend_pages_frontend_recommendations_similar_url
    assert_response :success
  end

  test "should get frontend_recommendations_similar_complementary" do
    get frontend_pages_frontend_recommendations_similar_complementary_url
    assert_response :success
  end

  test "should get frontend_search_2nd_page" do
    get frontend_pages_frontend_search_2nd_page_url
    assert_response :success
  end

  test "should get frontend_search_autocomplete_basic" do
    get frontend_pages_frontend_search_autocomplete_basic_url
    assert_response :success
  end

  test "should get frontend_search_autocomplete_categories" do
    get frontend_pages_frontend_search_autocomplete_categories_url
    assert_response :success
  end

  test "should get frontend_search_autocomplete_items" do
    get frontend_pages_frontend_search_autocomplete_items_url
    assert_response :success
  end

  test "should get frontend_search_autocomplete_items_bundled" do
    get frontend_pages_frontend_search_autocomplete_items_bundled_url
    assert_response :success
  end

  test "should get frontend_search_autocomplete_property" do
    get frontend_pages_frontend_search_autocomplete_property_url
    assert_response :success
  end

  test "should get frontend_search_basic" do
    get frontend_pages_frontend_search_basic_url
    assert_response :success
  end

  test "should get frontend_search_corrected" do
    get frontend_pages_frontend_search_corrected_url
    assert_response :success
  end

  test "should get frontend_search_debug_request" do
    get frontend_pages_frontend_search_debug_request_url
    assert_response :success
  end

  test "should get frontend_search_facet" do
    get frontend_pages_frontend_search_facet_url
    assert_response :success
  end

  test "should get frontend_search_facet_category" do
    get frontend_pages_frontend_search_facet_category_url
    assert_response :success
  end

  test "should get frontend_search_facet_model" do
    get frontend_pages_frontend_search_facet_model_url
    assert_response :success
  end

  test "should get frontend_search_facet_price" do
    get frontend_pages_frontend_search_facet_price_url
    assert_response :success
  end

  test "should get frontend_search_filter" do
    get frontend_pages_frontend_search_filter_url
    assert_response :success
  end

  test "should get frontend_search_filter_advanced" do
    get frontend_pages_frontend_search_filter_advanced_url
    assert_response :success
  end

  test "should get frontend_search_request_context_parameters" do
    get frontend_pages_frontend_search_request_context_parameters_url
    assert_response :success
  end

  test "should get frontend_search_return_fields" do
    get frontend_pages_frontend_search_return_fields_url
    assert_response :success
  end

  test "should get frontend_search_sort_field" do
    get frontend_pages_frontend_search_sort_field_url
    assert_response :success
  end

  test "should get frontend_search_sub_phrases" do
    get frontend_pages_frontend_search_sub_phrases_url
    assert_response :success
  end

end
