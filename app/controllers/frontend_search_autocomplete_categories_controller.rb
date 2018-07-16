class FrontendSearchAutocompleteCategoriesController < ApplicationController
  def frontend_search_autocomplete_categories (account = "csharp_unittest", password ="csharp_unittest", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil)
  	require 'json'
    require 'BxClient'
    require 'BxAutocompleteRequest'
    require 'BxFacets'
    #required parameters you should set for this example to work
    @account = account # your account name
    @password = password # your account password
    @host =  bxHost
    @exception = exception
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    if(!mockRequest.nil?)
      request = mockRequest
    else
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_autocomplete_categories/frontend_search_autocomplete_categories","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end
    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
    bxClient.setCookieContainer(cookies)
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
      @exception = e
    end
  end
end
