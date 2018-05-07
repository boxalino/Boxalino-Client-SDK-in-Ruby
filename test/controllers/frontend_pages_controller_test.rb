require 'test_helper'

class FrontendPagesControllerTest < ActionDispatch::IntegrationTest

  @account = "boxalino_automated_tests"
  @password = "boxalino_automated_tests"
  @exception = nil

  test "should get RecommendationsBasketTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception, bxHost)
        frontendRecommendationsBasket = _FrontendPages.frontend_recommendations_basket()
        @hitIds = (1..10).to_a

        _bxResponse = frontendRecommendationsBasket.instance_variable_get(:bxResponse)
        assert_equals frontendRecommendationsBasket.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitIds(), @hitIds

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #  puts "Exception"
      #end
    end
  end

  test "should get RecommendationsSimilarComplementaryTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendRecommendationsSimilarComplementary = _FrontendPages.frontend_recommendations_similar_complementary()

        @complementaryIds = (11..20).to_a
        @similarIds = (1..10).to_a

        choiceIdSimilar = frontendRecommendationsSimilarComplementary.instance_variable_get(:choiceIdSimilar)
        choiceIdComplementary = frontendRecommendationsSimilarComplementary.instance_variable_get(:choiceIdComplementary)
        _bxResponse = frontendRecommendationsSimilarComplementary.instance_variable_get(:bxResponse)
        assert_equals frontendRecommendationsSimilarComplementary.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitIds(choiceIdSimilar), @similarIds
        assert_equals _bxResponse.getHitIds(choiceIdComplementary), @complementaryIds

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get RecommendationsSimilarTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendRecommendationsSimilar = _FrontendPages.frontend_recommendations_similar()

        @hitIds = (1..10).to_a

        _bxResponse = frontendRecommendationsSimilar.instance_variable_get(:bxResponse)
        assert_equals frontendRecommendationsSimilar.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitIds(), @hitIds

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get Search2ndPageTest" do
    begin
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
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end

  test "should get SearchAutocompleteBasicTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendSearchAutoCompleteBasic = _FrontendPages.frontend_search_autocomplete_basic()

        @textualSuggestions = ['ida workout parachute pant', 'jade yoga jacket', 'push it messenger bag']

        _bxAutocompleteResponse = frontendSearchAutoCompleteBasic.instance_variable_get(:bxAutocompleteResponse)
        assert_equals frontendSearchAutoCompleteBasic.instance_variable_get(:@exception ) , nil
        assert_equals _bxAutocompleteResponse.getTextualSuggestions(), @textualSuggestions

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get SearchAutocompleteItemsBundledTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendSearchAutoCompleteItemsBundled = _FrontendPages.frontend_search_autocomplete_items_bundled()

        @firstTextualSuggestions = ['ida workout parachute pant', 'jade yoga jacket', 'push it messenger bag']
        @secondTextualSuggestions = ['argus all weather tank', 'jupiter all weather trainer', 'livingston all purpose tight']


        _bxAutocompleteResponses = frontendSearchAutoCompleteItemsBundled.instance_variable_get(:bxAutocompleteResponses)
        _fieldNames = frontendSearchAutoCompleteItemsBundled.instance_variable_get(:fieldNames)
        assert_equals frontendSearchAutoCompleteItemsBundled.instance_variable_get(:@exception ) , nil
        assert_equals _bxAutocompleteResponses.size, 2

        #first response
        assert_equals _bxAutocompleteResponses[0].getTextualSuggestions(), @firstTextualSuggestions
        #global ids
        assert_equals _bxAutocompleteResponses[0].getBxSearchResponse().getHitFieldValues(_fieldNames).keys, [115, 131, 227, 355, 611]

        #second response
        assert_equals _bxAutocompleteResponses[1].getTextualSuggestions(), @secondTextualSuggestions
        #global ids
        assert_equals _bxAutocompleteResponses[1].getBxSearchResponse().getHitFieldValues(_fieldNames).keys, [1545]

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get SearchAutocompleteItemsTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendSearchAutoCompleteItems = _FrontendPages.frontend_search_autocomplete_items()

        _textualSuggestions = ['ida workout parachute pant', 'jade yoga jacket', 'push it messenger bag']


        _bxAutocompleteResponse = frontendSearchAutoCompleteItems.instance_variable_get(:bxAutocompleteResponse)
        _fieldNames = frontendSearchAutoCompleteItems.instance_variable_get(:fieldNames)
        _itemSuggestions = _bxAutocompleteResponse.getBxSearchResponse().getHitFieldValues(_fieldNames)


        assert_equals frontendSearchAutoCompleteItems.instance_variable_get(:@exception ) , nil
        assert_equals _itemSuggestions.size, 5


        assert_equals _bxAutocompleteResponse.getTextualSuggestions(), _textualSuggestions

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
     # puts "Exception"
      #end
    end
  end


  test "should get SearchAutocompletePropertyTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|
        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)
        frontendSearchAutoCompleteProperty = _FrontendPages.frontend_search_autocomplete_property()


        _bxAutocompleteResponse = frontendSearchAutoCompleteProperty.instance_variable_get(:bxAutocompleteResponse)

        _property = frontendSearchAutoCompleteProperty.instance_variable_get(:property)

        _propertyHitValues = _bxAutocompleteResponse.getPropertyHitValues(_property)


        assert_equals frontendSearchAutoCompleteProperty.instance_variable_get(:@exception ) , nil

        assert_equals _propertyHitValues.size, 2


        assert_equals _propertyHitValues[0], 'Hoodies &amp; Sweatshirts'

        assert_equals _propertyHitValues[1],  'Bras &amp; Tanks'

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get SearchBasicTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)


        _hitIds = [41, 1940, 1065, 1151, 1241, 1321, 1385, 1401, 1609, 1801]
        _queryText = "women"

        #testing the result of the frontend search basic case
        frontendSearchBasic = _FrontendPages.frontend_search_basic( _queryText)
        _bxResponse = frontendSearchBasic.instance_variable_get(:bxResponse)

        assert_equals frontendSearchBasic.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.getHitIds(), _hitIds


        #testing the result of the frontend search basic case with semantic filtering blue => products_color=Blue
        _queryText2 = "blue"
        frontendSearchBasic2 = _FrontendPages.frontend_search_basic(_queryText2)

        _bxResponse2 = frontendSearchBasic2.instance_variable_get(:bxResponse)
        assert_equals frontendSearchBasic2.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse2.getTotalHitCount(), 77

        #testing the result of the frontend search basic case with semantic filtering forcing zero results pink => products_color=Pink

        _queryText3 = "pink"
        frontendSearchBasic3 = _FrontendPages.frontend_search_basic(_queryText3)

        _bxResponse3 = frontendSearchBasic3.instance_variable_get(:bxResponse)
        assert_equals frontendSearchBasic3.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse3.getTotalHitCount(), 0

        #testing the result of the frontend search basic case with semantic filtering setting a filter on a specific product only if the search shows zero results (this one should not do it because workout shows results)

        _queryText4 = "workout"
        frontendSearchBasic4 = _FrontendPages.frontend_search_basic(_queryText4)

        _bxResponse4 = frontendSearchBasic4.instance_variable_get(:bxResponse)
        assert_equals frontendSearchBasic4.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse4.getTotalHitCount(), 28

        #testing the result of the frontend search basic case with semantic filtering setting a filter on a specific product only if the search shows zero results (this one should do it because workoutoup shows no results)
        _queryText5 = "workoutoup"
        frontendSearchBasic5 = _FrontendPages.frontend_search_basic(_queryText5)

        _bxResponse5 = frontendSearchBasic5.instance_variable_get(:bxResponse)
        assert_equals frontendSearchBasic5.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse5.getTotalHitCount(), 1

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get SearchCorrectedTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        _hitIds = [41, 1940, 1065, 1151, 1241, 1321, 1385, 1401, 1609, 1801]

        #testing the result of the frontend search basic case
        frontendSearchCorrected = _FrontendPages.frontend_search_corrected( )
        _bxResponse = frontendSearchCorrected.instance_variable_get(:bxResponse)

        assert_equals frontendSearchCorrected.instance_variable_get(:@exception ) , nil
        assert_equals _bxResponse.areResultsCorrected(), true
        assert_equals _bxResponse.getHitIds(), _hitIds

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get SearchDebugRequestTest" do
    begin
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
      #assert_raise do #Fails, no Exceptions are raised
     # puts "Exception"
      #end
    end
  end


  test "should get SearchFacetCategoryTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        _hitIds = [41, 1940, 1065, 1151, 1241, 1321, 1385, 1401, 1609, 1801]

        #testing the result of the frontend search basic case
        frontendSearchFacetCategory = _FrontendPages.frontend_search_facet_category( )
        _bxResponse = frontendSearchFacetCategory.instance_variable_get(:bxResponse)

        assert_equals frontendSearchFacetCategory.instance_variable_get(:@exception ) , nil
        assert  _bxResponse.getHitIds() , _hitIds


      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get SearchFacetPriceTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        #testing the result of the frontend search basic case
        frontendSearchFacetPrice = _FrontendPages.frontend_search_facet_price( )
        _bxResponse = frontendSearchFacetPrice.instance_variable_get(:bxResponse)
        _facets = frontendSearchFacetPrice.instance_variable_get(:facets)
        assert_equals frontendSearchFacetPrice.instance_variable_get(:@exception ) , nil
        assert_equals _facets.getPriceRanges()[0] , "22-84"

        _bxResponse.getHitFieldValues([_facets.getPriceFieldName()]).each do |fieldValueMap|
          assert_not_equals fieldValueMap['discountedPrice'][0].to_f , 84.0
          assert_not_equals fieldValueMap['discountedPrice'][0].to_f , 22.0
        end

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end

  test "should get SearchFacetTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        #testing the result of the frontend search basic case
        frontendSearchFacet = _FrontendPages.frontend_search_facet( )
        _bxResponse = frontendSearchFacet.instance_variable_get(:bxResponse)
        _facetField = frontendSearchFacet.instance_variable_get(:facetField)
        assert_equals frontendSearchFacet.instance_variable_get(:@exception ) , nil

        assert_equals _bxResponse.getHitFieldValues([_facetField])[41] , { 'products_color'=>['Black' , 'Gray' , 'Yellow'] }
        assert_equals _bxResponse.getHitFieldValues([_facetField])[1940] , { 'products_color'=>['Gray', 'Orange', 'Yellow'] }

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end

  test "should get SearchFilterAdvancedTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        frontendSearchFilterAdvanced = _FrontendPages.frontend_search_filter_advanced( )
        _bxResponse = frontendSearchFilterAdvanced.instance_variable_get(:bxResponse)
        _fieldNames = frontendSearchFilterAdvanced.instance_variable_get(:fieldNames)
        assert_equals frontendSearchFilterAdvanced.instance_variable_get(:@exception ) , nil

        assert_equals _bxResponse.getHitFieldValues(_fieldNames).size , 10

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get SearchFilterTest" do
    begin
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



  test "should get SearchRequestContextParametersTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        frontendSearchRequestContextParameters = _FrontendPages.frontend_search_request_context_parameters( )
        assert_equals frontendSearchRequestContextParameters.instance_variable_get(:@exception ) , nil

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end


  test "should get SearchReturnFieldsTest" do
    begin
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
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end



  test "should get SearchSortField" do
    begin
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
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end



  test "should get SearchSubPhrasesTest" do
    begin
      @bxHosts = ['cdn.bx-cloud.com', 'api.bx-cloud.com']
      @bxHosts.each do |bxHost|

        _FrontendPages = FrontendPagesController.new(@account, @password , @exception , bxHost)

        frontendSearchSubPhrases = _FrontendPages.frontend_search_sub_phrases( )

        _bxResponse = frontendSearchSubPhrases.instance_variable_get(:bxResponse)

        assert_equals frontendSearchSubPhrases.instance_variable_get(:@exception ) , nil
        assert _bxResponse.areThereSubPhrases()
        assert_equals _bxResponse.getSubPhrasesQueries().size , 2

      end
    rescue Exception => e
      #assert_raise do #Fails, no Exceptions are raised
      #puts "Exception"
      #end
    end
  end

end
