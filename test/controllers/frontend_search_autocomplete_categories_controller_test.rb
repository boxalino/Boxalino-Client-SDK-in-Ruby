require 'test_helper'

class FrontendSearchAutocompleteCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get frontend_search_autocomplete_categories" do
    get frontend_search_autocomplete_categories_frontend_search_autocomplete_categories_url
    assert_response :success
  end

end
