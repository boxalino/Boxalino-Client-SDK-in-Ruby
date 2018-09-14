class FrontendSearchFacetPriceController < ApplicationController
  attr_accessor :bxResponse
  attr_reader :bxResponse
  attr_accessor :facets
  attr_reader :facets
  attr_accessor :exception
  attr_reader :exception
  @bxResponse
  @facets
  @exception
  def frontend_search_facet_price (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil )
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_facet_price/frontend_search_facet_price","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request, params)
    bxClient.setCookieContainer(cookies)
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      #selectedValue = isset($_REQUEST['bx_price']) ? $_REQUEST['bx_price'] : null;
      selectedValue = nil

      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)

      #//add a facert
      @facets =  BxFacets.new()
      @facets.addPriceRangeFacet(selectedValue)
      bxRequest.setFacets(facets)

      #//set the fields to be returned for each item in the response
      bxRequest.setReturnFields([facets.getPriceFieldName()])

      #//add the request
      bxClient.addRequest(bxRequest)

      #//make the query to Boxalino server and get back the response for all requests
      @bxResponse = bxClient.getResponse()

      #//get the facet responses
      @facets = bxResponse.getFacets()

      #//loop on the search response hit ids and print them
      @facets.getPriceRanges().each do |fieldValue|
        range = "<a href=\"?bx_price=" + facets.getPriceValueParameterValue(fieldValue) + "\">" + facets.getPriceValueLabel(fieldValue) + "</a> (" + facets.getPriceValueCount(fieldValue).to_s + ")"
        if(facets.isPriceValueSelected(fieldValue))
          range = range+  "<a href=\"?\">[X]</a>"
        end
        @logs.push(range)
      end

      #//loop on the search response hit ids and print them
      @bxResponse.getHitFieldValues([facets.getPriceFieldName()]).each do |id , fieldValueMap|
        @logs.push("<h3>"+id+"</h3>")
        fieldValueMap.each do |fieldName , fieldValues|
          @logs.push("Price: " + fieldValues.join(','))
        end
      end

      @message = @logs.join("<br/>")

    rescue Exception => e

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      @exception = e.backtrace
    end
  end
end
