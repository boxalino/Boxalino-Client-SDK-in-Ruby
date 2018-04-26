class FrontendPagesController < ApplicationController
  def frontend_parametrized_request
    require 'json'
    require 'BxClient'
    require 'BxParametrizedRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      choiceId = "productfinder" #the recommendation choice id (standard choice ids are: "similar" => similar products on product detail page, "complementary" => complementary products on product detail page, "basket" => cross-selling recommendations on basket page, "search"=>search results, "home" => home page personalized suggestions, "category" => category page suggestions, "navigation" => navigation product listing pages suggestions)
      hitCount = 10 #a maximum number of recommended result to return in one page
      requestWeightedParametersPrefix = "bxrpw_"
      requestFiltersPrefix = "bxfi_"
      requestFacetsPrefix = "bxfa_"
      requestSortFieldPrefix = "bxsf_"
      requestReturnFieldsName= "bxrf"
      
      bxReturnFields = ['id'] #the list of fields which should be returned directly by Boxalino, the others will be retrieved through a call-back function
      getItemFieldsCB = "getItemFieldsCB"
      
      #//create the request and set the parameter prefix values
      bxRequest = BxParametrizedRequest.new(language, choiceId, hitCount, 0, bxReturnFields, getItemFieldsCB)
      bxRequest.setRequestWeightedParametersPrefix(requestWeightedParametersPrefix)
      bxRequest.setRequestFiltersPrefix(requestFiltersPrefix)
      bxRequest.setRequestFacetsPrefix(requestFacetsPrefix)
      bxRequest.setRequestSortFieldPrefix(requestSortFieldPrefix)
      
      bxRequest.setRequestReturnFieldsName(requestReturnFieldsName)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      @logs.push("<h3>weighted parameters</h3>")
      bxRequest.getWeightedParameters().each  do |fieldName , fieldValues|
        fieldValues.each do |fieldValue , weight|
          @logs.push(fieldName+": "+fieldValue+": "+weight)
        end
      end
      @logs.push("..")
      
      @logs.push("<h3>filters</h3>")
      bxRequest.getFilters().each do |bxFilter|
        @logs.push(bxFilter.getFieldName() + ": " + bxFilter.getValues().join(',') + " :" + bxFilter.isNegative())
      end
      @logs.push("..")
      
      @logs.push("<h3>facets</h3>")
      bxFacets = bxRequest.getFacets()
      bxFacets.getFieldNames().each do |fieldName|
        @logs.push(fieldName+": " + bxFacets.getSelectedValues(fieldName).join(','))
      end
      @logs.push("..")
      
      @logs.push("<h3>sort fields</h3>")
      bxSortFields = bxRequest.getSortFields()
      bxSortFields.getSortFields().each do |fieldName|
        @logs.push(fieldName+": " + bxSortFields.isFieldReverse(fieldName))
      end
      @logs.push("..")
      
      #//loop on the recommended response hit ids and print them
      @logs.push("<h3>results</h3>")
      @logs.push(bxResponse.toJson(bxRequest.getAllReturnFields()))

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

def getItemFieldsCB(ids, fieldNames) 
  #todo your code here to retrieve the fields values
  values = Array.new
  ids.each do |id|
    values[id] = Array.new
    fieldNames.each  do |fieldName|
      values[id][fieldName] = [fieldName + "-value"]
    end
  end
  return values
end

  def frontend_recommendations_basket
    require 'json'
    require 'BxClient'
    require 'BxRecommendationRequest'
    #required parameters you should set for this example to work
    @account = "boxalino_automated_tests"; # your account name
    @password = "boxalino_automated_tests"; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      choiceId = "basket" #the recommendation choice id (standard choice ids are: "similar" => similar products on product detail page, "complementary" => complementary products on product detail page, "basket" => cross-selling recommendations on basket page, "search"=>search results, "home" => home page personalized suggestions, "category" => category page suggestions, "navigation" => navigation product listing pages suggestions)
      itemFieldId = "id" # the field you want to use to define the id of the product (normally id, but could also be a group id if you have a difference between group id and sku)
      itemFieldIdValuesPrices = [{:id=>"1234", :price=>130.5},{:id=>"1940", :price=>10.80}] #the product ids and their prices that the user currently has in his basket
      hitCount = 10 #a maximum number of recommended result to return in one page

      #//create similar recommendations request
      bxRequest = BxRecommendationRequest.new(language, choiceId, hitCount)
      
      #//indicate the products the user currently has in his basket (reference of products for the recommendations)
      bxRequest.setBasketProductWithPrices(itemFieldId, itemFieldIdValuesPrices)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//loop on the recommended response hit ids and print them
      bxResponse.getHitIds().each do |i , id|
        @logs.push(i+": returned id "+id)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_recommendations_similar
    require 'json'
    require 'BxClient'
    require 'BxRecommendationRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      choiceId = "similar" #the recommendation choice id (standard choice ids are: "similar" => similar products on product detail page, "complementary" => complementary products on product detail page, "basket" => cross-selling recommendations on basket page, "search"=>search results, "home" => home page personalized suggestions, "category" => category page suggestions, "navigation" => navigation product listing pages suggestions)
      itemFieldId = "id" # the field you want to use to define the id of the product (normally id, but could also be a group id if you have a difference between group id and sku)
      itemFieldIdValue = "1940" #the product id the user is currently looking at
      hitCount = 10 #a maximum number of recommended result to return in one page

      #//create similar recommendations request
      bxRequest = BxRecommendationRequest.new(language, choiceId, hitCount)
      
      #//indicate the product the user is looking at now (reference of what the recommendations need to be similar to)
      bxRequest.setProductContext(itemFieldId, itemFieldIdValue)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//loop on the recommended response hit ids and print them
      bxResponse.getHitIds().each do |i , id|
        @logs.push(i+": returned id "+id)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_recommendations_similar_complementary
    require 'json'
    require 'BxClient'
    require 'BxRecommendationRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      choiceIdSimilar = "similar" #the recommendation choice id (standard choice ids are: "similar" => similar products on product detail page, "complementary" => complementary products on product detail page, "basket" => cross-selling recommendations on basket page, "search"=>search results, "home" => home page personalized suggestions, "category" => category page suggestions, "navigation" => navigation product listing pages suggestions)
      choiceIdComplementary = "complementary"
      itemFieldId = "id" # the field you want to use to define the id of the product (normally id, but could also be a group id if you have a difference between group id and sku)
      itemFieldIdValue = "1940" #the product id the user is currently looking at
      hitCount = 10 #a maximum number of recommended result to return in one page

      #//create similar recommendations request
      bxRequestSimilar = BxRecommendationRequest.new(language, choiceIdSimilar, hitCount)
      #//indicate the product the user is looking at now (reference of what the recommendations need to be similar to)
      bxRequestSimilar.setProductContext(itemFieldId, itemFieldIdValue)
      #//add the request
      bxClient.addRequest(bxRequestSimilar)
      
      
      #//create complementary recommendations request
      bxRequestComplementary = BxRecommendationRequest.new(language, choiceIdComplementary, hitCount)
      #//indicate the product the user is looking at now (reference of what the recommendations need to be similar to)
      bxRequestComplementary.setProductContext(itemFieldId, itemFieldIdValue)
      #//add the request
      bxClient.addRequest(bxRequestComplementary)
      
      #//make the query to Boxalino server and get back the response for all requests (make sure you have added all your requests before calling getResponse; i.e.: do not push the first request, then call getResponse, then add a new request, then call getResponse again it wil not work; N.B.: if you need to do to separate requests call, then you cannot reuse the same instance of BxClient, but need to create a new one)
      bxResponse = bxClient.getResponse()
      
      #//loop on the recommended response hit ids and print them
      @logs.push("recommendations of similar items:")
      bxResponse.getHitIds(choiceIdSimilar).each do |i , id|
        @logs.push(i+": returned id "+id)
      end
      @logs.push("")

      #//retrieve the recommended responses object of the complementary request
      @logs.push("recommendations of complementary items:")
      #//loop on the recommended response hit ids and print them
      bxResponse.getHitIds(choiceIdComplementary).each do |i , id|
        @logs.push(i+": returned id "+id)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_2nd_page
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "watch" # a search query
      hitCount = 5 #a maximum number of search result to return in one page
      offset = 5 #the offset to start the page with (if = hitcount ==> page 2)
      
      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//set an offset for the returned search results (start at position provided)
      bxRequest.setOffset(offset)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//loop on the search response hit ids and print them
      bxResponse.getHitIds().each do |i , id|
        @logs.push(i+": returned id "+id)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_autocomplete_basic
    require 'json'
    require 'BxClient'
    require 'BxAutocompleteRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "whit" # a search query to be completed
      textualSuggestionsHitCount = 10 #a maximum number of search textual suggestions to return in one page

      #//create search request
      bxRequest = BxAutocompleteRequest.new(language, queryText, textualSuggestionsHitCount)
      
      #//set the request
      bxClient.setAutocompleteRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxAutocompleteResponse = bxClient.getAutocompleteResponse()
      
      #//loop on the search response hit ids and print them
      @logs.push("textual suggestions for "+queryText+":")
      bxAutocompleteResponse.getTextualSuggestions().each do |suggestion|
        @logs.push(bxAutocompleteResponse.getTextualSuggestionHighlighted(suggestion))
      end
      
      if(bxAutocompleteResponse.getTextualSuggestions().size== 0) 
        @logs.push("There are no autocomplete textual suggestions. This might be normal, but it also might mean that the first execution of the autocomplete index preparation was not done and published yet. Please refer to the example backend_data_init and make sure you have done the following steps at least once: 1) publish your data 2) run the prepareAutocomplete case 3) publish your data again");
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_autocomplete_categories
    require 'json'
    require 'BxClient'
    require 'BxAutocompleteRequest'
    require 'BxFacets'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "whit" # a search query to be completed
      textualSuggestionsHitCount = 10 #a maximum number of search textual suggestions to return in one page

      #//create search request
      bxRequest = BxAutocompleteRequest.new(language, queryText, textualSuggestionsHitCount)
      
      bxSearchRequest = bxRequest.getBxSearchRequest()
      
      facets = BxFacets.new()
      facets.addCategoryFacet()
      bxSearchRequest.setFacets(facets)
      
      #//set the request
      bxClient.setAutocompleteRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxAutocompleteResponse = bxClient.getAutocompleteResponse()
      
      #//loop on the search response hit ids and print them
      @logs.push("textual suggestions for "+queryText+":")
      i = 0
      bxAutocompleteResponse.getTextualSuggestions().each do |suggestion|
        @logs.push(bxAutocompleteResponse.getTextualSuggestionHighlighted($suggestion))
        if(i == 0) 
          bxAutocompleteResponse.getTextualSuggestionFacets(suggestion).getCategories().each do |value|
            @logs.push("<a href=\"?bx_category_id=" + facets.getCategoryValueId(value) + "\">" + facets.getCategoryValueLabel(value) + "</a> (" + facets.getCategoryValueCount(value) + ")")
          end
        end
        i = i+1
      end
      
      if(bxAutocompleteResponse.getTextualSuggestions().size == 0) 
        @logs.push("There are no autocomplete textual suggestions. This might be normal, but it also might mean that the first execution of the autocomplete index preparation was not done and published yet. Please refer to the example backend_data_init and make sure you have done the following steps at least once: 1) publish your data 2) run the prepareAutocomplete case 3) publish your data again")
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_autocomplete_items
    require 'json'
    require 'BxClient'
    require 'BxAutocompleteRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "whit" # a search query to be completed
      textualSuggestionsHitCount = 10 #a maximum number of search textual suggestions to return in one page
      fieldNames = ['title'] #return the title for each item returned (globally and per textual suggestion) - IMPORTANT: you need to put "products_" as a prefix to your field name except for standard fields: "title", "body", "discountedPrice", "standardPrice"

      #//create search request
      bxRequest = BxAutocompleteRequest.new(language, queryText, textualSuggestionsHitCount)
      
      #//set the fields to be returned for each item in the response
      bxRequest.getBxSearchRequest().setReturnFields(fieldNames)
      
      #//set the request
      bxClient.setAutocompleteRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxAutocompleteResponse = bxClient.getAutocompleteResponse()

      #//loop on the search response hit ids and print them
      @logs.push("textual suggestions for "+queryText+":<br>")
      bxAutocompleteResponse.getTextualSuggestions().each do |suggestion|
        @logs.push("<div style=\"border:1px solid; padding:10px; margin:10px\">")
        @logs.push("<h3>"+suggestion+"</b></h3>")

        @logs.push("item suggestions for suggestion "+suggestion+":<br>")
        #//loop on the search response hit ids and print them
        bxAutocompleteResponse.getBxSearchResponse(suggestion).getHitFieldValues(fieldNames).each do |id , fieldValueMap|
          @logs.push("<div>"+id);
          fieldValueMap.each  do |fieldName , fieldValues|
            @logs.push(" - "+fieldName+": " + fieldValues.join(',') )
          end
          @logs.push("</div>")
        end
        @logs.push("</div>")
      end

      @logs.push("global item suggestions for "+queryText+":<br>")
      #//loop on the search response hit ids and print them
      bxAutocompleteResponse.getBxSearchResponse().getHitFieldValues(fieldNames).each do |id ,fieldValueMap|
        item = id
        fieldValueMap.each do |fieldName , fieldValues|
          item = item + " - "+fieldName+": " + fieldValues.join(',') + "<br>"
        end
        @logs.push(item)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_autocomplete_items_bundled
    require 'json'
    require 'BxClient'
    require 'BxAutocompleteRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryTexts = ["whit", "yello"] # a search query to be completed
      textualSuggestionsHitCount = 10 #a maximum number of search textual suggestions to return in one page
      fieldNames = ['title'] #return the title for each item returned (globally and per textual suggestion) - IMPORTANT: you need to put "products_" as a prefix to your field name except for standard fields: "title", "body", "discountedPrice", "standardPrice"

      bxRequests = []
      queryTexts.each do |queryText|
        #//create search request
        bxRequest = BxAutocompleteRequest.new(language, queryText, textualSuggestionsHitCount)
        
        #//N.B.: in case you would want to set a filter on a request and not another, you can simply do it by getting the searchchoicerequest with: $bxRequest->getBxSearchRequest() and adding a filter
        
        #//set the fields to be returned for each item in the response
        bxRequest.getBxSearchRequest().setReturnFields(fieldNames)
        bxRequests.push(bxRequest)

      end
      
      #//set the request
      bxClient.setAutocompleteRequests(bxRequests)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxAutocompleteResponses = bxClient.getAutocompleteResponses()
      i = -1
      bxAutocompleteResponses.each do |bxAutocompleteResponse|

        #//loop on the search response hit ids and print them
        queryText = queryTexts[++i]
        @logs.push("<h2>textual suggestions for "+queryText+":</h2>")
        bxAutocompleteResponse.getTextualSuggestions().each do |suggestion|
          @logs.push("<div style=\"border:1px solid; padding:10px; margin:10px\">");
          @logs.push("<h3>"+suggestion+"</b></h3>")

          @logs.push("item suggestions for suggestion "+suggestion+":")
          #//loop on the search response hit ids and print them
          bxAutocompleteResponse.getBxSearchResponse(suggestion).getHitFieldValues(fieldNames).each do |id ,fieldValueMap|
            @logs.push("<div>"+id)
            fieldValueMap.each do |fieldName , fieldValues|
              @logs.push(" - "+fieldName+": " + fieldValues.join(','))
            end
            @logs.push("</div>")
          end
          @logs.push("</div>")
        end

        @logs.push("<h2>global item suggestions for "+queryText+":</h2>")
        #loop on the search response hit ids and print them
        bxAutocompleteResponse.getBxSearchResponse().getHitFieldValues(fieldNames).each do |id , fieldValueMap|
          @logs.push("<div>"+id)
          fieldValueMap.each do |fieldName , fieldValues|
            @logs.push(" - "+fieldName+": " +fieldValues.join(','))
          end
          @logs.push("</div>")
        end
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message = e
      
    end
  end

  def frontend_search_autocomplete_property
    require 'json'
    require 'BxClient'
    require 'BxAutocompleteRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "a" # a search query to be completed
      textualSuggestionsHitCount = 10 #a maximum number of search textual suggestions to return in one page
      property = 'categories' #the properties to do a property autocomplete request on, be careful, except the standard "categories" which always work, but return values in an encoded way with the path ( "ID/root/level1/level2"), no other properties are available for autocomplete request on by default, to make a property "searcheable" as property, you must set the field parameter "propertyIndex" to "true"
      propertyTotalHitCount = 5 #the maximum number of property values to return
      propertyEvaluateCounters = true #should the count of results for each property value be calculated? if you do not need to retrieve the total count for each property value, please leave the 3rd parameter empty or set it to false, your query will go faster

      #//create search request
      bxRequest = BxAutocompleteRequest.new(language, queryText, textualSuggestionsHitCount)
      
      #//indicate to the request a property index query is requested
      bxRequest.addPropertyQuery(property, propertyTotalHitCount, true)
      
      #//set the request
      bxClient.setAutocompleteRequest(bxRequest)
      #make the query to Boxalino server and get back the response for all requests
      bxAutocompleteResponse = bxClient.getAutocompleteResponse()

      #//loop on the search response hit ids and print them
      @logs.push("property suggestions for "+queryText+":<br>")
      bxAutocompleteResponse.getPropertyHitValues(property).each do |hitValue|
        label = bxAutocompleteResponse.getPropertyHitValueLabel(property, hitValue)
        totalHitCount = bxAutocompleteResponse.getPropertyHitValueTotalHitCount(property, hitValue)
        result = "<b>"+hitValue+":</b><ul><li>label="+label+"</li> <li>totalHitCount="+totalHitCount+"</li></ul>"
        @logs.push(result)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_basic
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText =  queryText.kind_of?nil ?  "women" : queryText  # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      
      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//indicate the search made with the number of results found
      @logs.push("Results for query " + queryText + " (" + bxResponse.getTotalHitCount() + "):")
      
      #//loop on the search response hit ids and print them
      bxResponse.getHitIds().each do |i , id|
        @logs.push(i+": returned id "+id)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_corrected
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "womem" # a search query
      hitCount = 10 #a maximum number of search result to return in one page

      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//if the query is corrected, then print the corrrect query text
      if(bxResponse.areResultsCorrected()) 
        @logs.push("Corrected query " + queryText + " into " + bxResponse.getCorrectedQuery())
      end
      
      #//loop on the search response hit ids and print them
      bxResponse.getHitIds().each do |i , id|
        @logs.push(i+": returned id "+id)
      end
      
      if(bxResponse.getHitIds().size == 0) 
        @logs = "There are no corrected results. This might be normal, but it also might mean that the first execution of the corpus preparation was not done and published yet. Please refer to the example backend_data_init and make sure you have done the following steps at least once: 1) publish your data 2) run the prepareCorpus case 3) publish your data again";
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_debug_request
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page

      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//print the request object which is sent to our server (please provide it to Boxalino in all your support requests)
        
      @message = bxClient.getThriftChoiceRequest()
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_facet
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    require 'BxFacets'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      facetField = "products_color" #the field to consider in the filter - IMPORTANT: you need to put "products_" as a prefix to your field name except for standard fields: "title", "body", "discountedPrice", "standardPrice"
      #selectedValue = isset($_REQUEST['bx_' . $facetField]) ? $_REQUEST['bx_' . $facetField] : null;
      selectedValue = nil

      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//set the fields to be returned for each item in the response
      bxRequest.setReturnFields([facetField])
      
      #//add a facert
      facets = BxFacets.new()
      facets.addFacet(facetField, selectedValue)
      bxRequest.setFacets(facets)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()

      #get the facet responses
      facets = bxResponse.getFacets()
      
      #//loop on the search response hit ids and print them
      facets.getFacetValues(facetField).each do |fieldValue|
        @logs.push("<a href=\"?bx_" + facetField + "=" + facets.getFacetValueParameterValue(facetField, fieldValue) + "\">" + facets.getFacetValueLabel(facetField, fieldValue) + "</a> (" + facets.getFacetValueCount(facetField, fieldValue) + ")")
        if(facets.isFacetValueSelected(facetField, fieldValue)) 
          @logs.push("<a href=\"?\">[X]</a>");
        end
      end

      #//loop on the search response hit ids and print them
      bxResponse.getHitFieldValues([facetField]).each do |id , fieldValueMap|
        @logs.push("<h3>"+id+"</h3>")
        fieldValueMap.each do |fieldName , fieldValues|
          @logs.push(fieldName+": " + fieldValues.join('.'))
        end
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_facet_category
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    require 'BxFacets'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      #selectedValue = isset($_REQUEST['bx_category_id']) ? $_REQUEST['bx_category_id'] : null;
      selectedValue = nil
      
      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//add a facert
      facets =  BxFacets.new()
      facets.addCategoryFacet(selectedValue)
      bxRequest.setFacets(facets)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//get the facet responses
      facets = bxResponse.getFacets()
      
      #//show the category breadcrumbs
      level = 0
      @logs.push("<a href=\"?\">home</a>")
      facets.getParentCategories().each do |categoryId , categoryLabel|
        @logs.push(">> <a href=\"?bx_category_id="+categoryId+"\">"+categoryLabel+"</a>")
        level = level +1
      end
      @logs.push(" ")
      #//show the category facet values
      facets.getCategories().each do |value|
        @logs.push("<a href=\"?bx_category_id=" + facets.getCategoryValueId(value) + "\">" + facets.getCategoryValueLabel(value) + "</a> (" + facets.getCategoryValueCount(value) + ")")
      end
       @logs.push(" ")
      
      #//loop on the search response hit ids and print them
      bxResponse.getHitIds().each do |i , id|
        @logs.push(i+": returned id "+id)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_facet_model
  end

  def frontend_search_facet_price
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    require 'BxFacets'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      #selectedValue = isset($_REQUEST['bx_price']) ? $_REQUEST['bx_price'] : null;
      selectedValue = nil

      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//add a facert
      facets =  BxFacets.new()
      facets.addPriceRangeFacet(selectedValue)
      bxRequest.setFacets(facets)
      
      #//set the fields to be returned for each item in the response
      bxRequest.setReturnFields([facets.getPriceFieldName()])
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse();
      
      #//get the facet responses
      facets = bxResponse.getFacets()

      #//loop on the search response hit ids and print them
      facets.getPriceRanges().each do |fieldValue|
        range = "<a href=\"?bx_price=" + facets.getPriceValueParameterValue(fieldValue) + "\">" + facets.getPriceValueLabel(fieldValue) + "</a> (" + facets.getPriceValueCount(fieldValue) + ")"
        if(facets.isPriceValueSelected(fieldValue)) 
          range = range+  "<a href=\"?\">[X]</a>"
        end
        @logs.push(range)
      end
      
      #//loop on the search response hit ids and print them
      bxResponse.getHitFieldValues([facets.getPriceFieldName()]).each do |id , fieldValueMap|
        @logs.push("<h3>"+id+"</h3>")
        fieldValueMap.each do |fieldName , fieldValues|
          @logs.push("Price: " + fieldValues.join(','))
        end
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_filter
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    require 'BxFilter'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      filterField = "id" #the field to consider in the filter
      filterValues = ["41", "1940"] #the field to consider any of the values should match (or not match)
      filterNegative = true #false by default, should the filter match the values or not?
      
      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//add a filter
      bxRequest.addFilter(BxFilter.new(filterField, filterValues, filterNegative))
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//loop on the search response hit ids and print them
      bxResponse.getHitIds().each do |i , id|
        @logs.push(i+": returned id "+id)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_filter_advanced
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    require 'BxFilter'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      filterField = "id" #the field to consider in the filter
      filterValues = ["41", "1941"] #the field to consider any of the values should match (or not match)
      filterNegative = true #false by default, should the filter match the values or not?
      filterField2 = "products_color" #the field to consider in the filter
      filterValues2 = ["Yellow"] #the field to consider any of the values should match (or not match)
      filterNegative2 = false #false by default, should the filter match the values or not?
      orFilters = true #the two filters are either or (only one of them needs to be correct
      fieldNames = ["products_color"] #IMPORTANT: you need to put "products_" as a prefix to your field name except for standard fields: "title", "body", "discountedPrice", "standardPrice"

      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//set the fields to be returned for each item in the response
      bxRequest.setReturnFields(fieldNames)
      
      #//add a filter
      bxRequest.addFilter(BxFilter.new(filterField,filterValues, filterNegative))
      bxRequest.addFilter(BxFilter.new(filterField2, filterValues2, filterNegative2))
      bxRequest.setOrFilters(orFilters)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//loop on the search response hit ids and print them
      bxResponse.getHitFieldValues(fieldNames).each do |id , fieldValueMap|
        @logs.push("<h3>"+id+"</h3>")
        fieldValueMap.each do |fieldName , fieldValues|
          @logs.push(fieldName+": " + fieldValues.join(','))
        end
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_request_context_parameters
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      
      requestParameters = {"geoIP-latitude" => ["47.36"], "geoIP-longitude" => ["6.1517993"]}
      
      #//create search request
      bxRequest =  BxSearchRequest.new(language, queryText, hitCount)
      
      #//set the fields to be returned for each item in the response
      requestParameters.each do |k , v| 
        bxClient.addRequestContextParameter(k, v)
      end
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//indicate the search made with the number of results found
      @logs.push("Results for query \"" + queryText + "\" (" + bxResponse.getTotalHitCount() + "):<br>")

      #//loop on the search response hit ids and print them
      bxResponse.getHitIds().each do |i,iid|
        @logs.push(i+": returned id "+iid)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_return_fields
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      
      fieldNames = ["products_color"] #//IMPORTANT: you need to put "products_" as a prefix to your field name except for standard fields: "title", "body", "discountedPrice", "standardPrice"
      
      #//create search request
      bxRequest =  BxSearchRequest.new(language, queryText, hitCount)
      
      #//set the fields to be returned for each item in the response
      bxRequest.setReturnFields(fieldNames)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()

      #//loop on the search response hit ids and print them
      bxResponse.getHitFieldValues(fieldNames).each do |id , fieldValueMap|
        entity = "<h3>"+id+"</h3>";
        fieldValueMap.each do |fieldName , fieldValues|
          entity = entity + fieldName+": " + fieldValues.join(',')
        end
        @logs.push(entity)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_sort_field
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      sortField = "title" #sort the search results by this field - IMPORTANT: you need to put "products_" as a prefix to your field name except for standard fields: "title", "body", "discountedPrice", "standardPrice"
      sortDesc = true #sort in an ascending / descending way

      #//create search request
      bxRequest = new BxSearchRequest(language, queryText, hitCount)
      
      #//add a sort field in the provided direction
      bxRequest.addSortField(sortField, sortDesc)
      
      #//set the fields to be returned for each item in the response
      bxRequest.setReturnFields([sortField])
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//loop on the search response hit ids and print them
      bxResponse.getHitFieldValues([sortField]).each do |id , fieldValueMap|
        product = "<h3>"+id+"</h3>"
        fieldValueMap.each do |fieldName , fieldValues|
          product = product + fieldName+": " + fieldValues.join(',')
        end
        @logs.push(product)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def frontend_search_sub_phrases
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    #required parameters you should set for this example to work
    @account = ""; # your account name
    @password = ""; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
     
      #//create search request
      bxRequest = new BxSearchRequest(language, queryText, hitCount)
      
      #//add a sort field in the provided direction
      bxRequest.addSortField(sortField, sortDesc)
      
      #//set the fields to be returned for each item in the response
      bxRequest.setReturnFields([sortField])
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      
      #//loop on the search response hit ids and print them
      bxResponse.getHitFieldValues([sortField]).each do |id , fieldValueMap|
        product = "<h3>"+id+"</h3>"
        fieldValueMap.each do |fieldName , fieldValues|
          product = product + fieldName+": " + fieldValues.join(',')
        end
        @logs.push(product)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end
end
