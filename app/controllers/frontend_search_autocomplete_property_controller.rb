class FrontendSearchAutocompletePropertyController < ApplicationController
  attr_accessor :bxAutocompleteResponse
  attr_reader :bxAutocompleteResponse
  attr_accessor :property
  attr_reader :property
  attr_accessor :exception
  attr_reader :exception
  @bxAutocompleteResponse
  @property
  @exception
  def frontend_search_autocomplete_property (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil)
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_autocomplete_property/frontend_search_autocomplete_property","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end
    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "a" # a search query to be completed
      textualSuggestionsHitCount = 10 #a maximum number of search textual suggestions to return in one page
      @property = 'categories' #the properties to do a property autocomplete request on, be careful, except the standard "categories" which always work, but return values in an encoded way with the path ( "ID/root/level1/level2"), no other properties are available for autocomplete request on by default, to make a property "searcheable" as property, you must set the field parameter "propertyIndex" to "true"
      propertyTotalHitCount = 5 #the maximum number of property values to return
      propertyEvaluateCounters = true #should the count of results for each property value be calculated? if you do not need to retrieve the total count for each property value, please leave the 3rd parameter empty or set it to false, your query will go faster

      #//create search request
      bxRequest = BxAutocompleteRequest.new(language, queryText, textualSuggestionsHitCount)
      
      #//indicate to the request a property index query is requested
      bxRequest.addPropertyQuery(property, propertyTotalHitCount, true)
      
      #//set the request
      bxClient.setAutocompleteRequest(bxRequest)
      #make the query to Boxalino server and get back the response for all requests
      @bxAutocompleteResponse = bxClient.getAutocompleteResponse()

      #//loop on the search response hit ids and print them
      @logs.push("property suggestions for "+queryText+":<br>")
      @bxAutocompleteResponse.getPropertyHitValues(property).each do |hitValue|
        label = bxAutocompleteResponse.getPropertyHitValueLabel(property, hitValue)
        totalHitCount = bxAutocompleteResponse.getPropertyHitValueTotalHitCount(property, hitValue)
        result = "<b>"+hitValue+":</b><ul><li>label="+label+"</li> <li>totalHitCount="+totalHitCount+"</li></ul>"
        @logs.push(result)
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      @exception = e
    end
  end
end
