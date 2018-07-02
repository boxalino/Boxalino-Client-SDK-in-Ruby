class FrontendSearchAutocompleteItemsController < ApplicationController
  attr_accessor :bxAutocompleteResponse
  attr_reader :bxAutocompleteResponse
  attr_accessor :exception
  attr_reader :exception
  attr_accessor :fieldNames
  attr_reader :fieldNames
  @bxAutocompleteResponse
  @exception
  @fieldNames
  def frontend_search_autocomplete_items (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil)
  	require 'json'
    require 'BxClient'
    require 'BxAutocompleteRequest'
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_autocomplete_items_bundled/frontend_search_autocomplete_items_bundled","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end
    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
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
      @bxAutocompleteResponse = bxClient.getAutocompleteResponse()

      #//loop on the search response hit ids and print them
      @logs.push("textual suggestions for "+queryText+":<br>")
      @bxAutocompleteResponse.getTextualSuggestions().each do |suggestion|
        @logs.push("<div style=\"border:1px solid; padding:10px; margin:10px\">")
        @logs.push("<h3>"+suggestion+"</b></h3>")

        @logs.push("item suggestions for suggestion "+suggestion+":<br>")
        #//loop on the search response hit ids and print them
        @bxAutocompleteResponse.getBxSearchResponse(suggestion).getHitFieldValues(fieldNames).each do |id , fieldValueMap|
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
      @bxAutocompleteResponse.getBxSearchResponse().getHitFieldValues(fieldNames).each do |id ,fieldValueMap|
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
      @exception = e
    end
  end
end
