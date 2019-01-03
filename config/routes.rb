Rails.application.routes.draw do

  get 'frontend_search_sub_phrases/frontend_search_sub_phrases'

  get 'frontend_search_two_page/frontend_search_two_page'

  get 'frontend_search_sort_field/frontend_search_sort_field'

  get 'frontend_search_return_fields/frontend_search_return_fields'

  get 'frontend_search_request_context_parameters/frontend_search_request_context_parameters'

  get 'frontend_search_filter_advanced/frontend_search_filter_advanced'

  get 'frontend_search_filter/frontend_search_filter'

  get 'frontend_search_facet_price/frontend_search_facet_price'

  get 'frontend_search_facet_category/frontend_search_facet_category'

  get 'frontend_search_facet/frontend_search_facet'

  get 'frontend_search_corrected/frontend_search_corrected'

  get 'frontend_search_basic/frontend_search_basic'

  get 'frontend_search_autocomplete_property/frontend_search_autocomplete_property'

  get 'frontend_search_autocomplete_items_bundled/frontend_search_autocomplete_items_bundled'

  get 'frontend_search_autocomplete_items/frontend_search_autocomplete_items'

  get 'frontend_search_autocomplete_categories/frontend_search_autocomplete_categories'

  get 'frontend_search_autocomplete_basic/frontend_search_autocomplete_basic'

  get 'frontend_recommendations_similar_complementary/frontend_recommendations_similar_complementary'

  get 'frontend_recommendations_basket/frontend_recommendations_basket'

  get 'frontend_parametrized_request/frontend_parametrized_request'

  get 'frontend_search_debug_request/frontend_search_debug_request'

  get 'frontend_recommendations_similar/frontend_recommendations_similar'

  get 'frontend_pages/frontend_parametrized_request'

  get 'frontend_pages/frontend_recommendations_basket'

  get 'frontend_pages/frontend_recommendations_similar'

  get 'frontend_pages/frontend_recommendations_similar_complementary'

  get 'frontend_pages/frontend_search_2nd_page'

  get 'frontend_pages/frontend_search_autocomplete_basic'

  get 'frontend_pages/frontend_search_autocomplete_categories'

  get 'frontend_pages/frontend_search_autocomplete_items'

  get 'frontend_pages/frontend_search_autocomplete_items_bundled'

  get 'frontend_pages/frontend_search_autocomplete_property'

  get 'frontend_pages/frontend_search_basic'

  get 'frontend_pages/frontend_search_corrected'

  get 'frontend_pages/frontend_search_debug_request'

  get 'frontend_pages/frontend_search_facet'

  get 'frontend_pages/frontend_search_facet_category'

  get 'frontend_pages/frontend_search_facet_model'

  get 'frontend_pages/frontend_search_facet_price'

  get 'frontend_pages/frontend_search_filter'

  get 'frontend_pages/frontend_search_filter_advanced'

  get 'frontend_pages/frontend_search_request_context_parameters'

  get 'frontend_pages/frontend_search_return_fields'

  get 'frontend_pages/frontend_search_sort_field'

  get 'frontend_pages/frontend_search_sub_phrases'

  get 'backend_pages/backend_data_basic'

  get 'backend_pages/backend_data_basic_xml'

  get 'backend_pages/backend_data_categories'

  get 'backend_pages/backend_data_categories_xml'

  get 'backend_pages/backend_data_customers'

  get 'backend_pages/backend_data_debug_xml'

  get 'backend_pages/backend_data_full_export'

  get 'backend_pages/backend_data_init'

  get 'backend_pages/backend_data_resource'

  get 'backend_pages/backend_data_resource_xml'

  get 'backend_pages/backend_data_split_field_values'

  get 'backend_pages/backend_data_transactions'

  get 'static_pages/backend_data_basic'

  get 'frontend_batch/frontend_batch'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
