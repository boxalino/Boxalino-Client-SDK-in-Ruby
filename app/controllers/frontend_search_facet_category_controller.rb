class FrontendSearchFacetCategoryController < ApplicationController
  attr_accessor :bxResponse
  attr_reader :bxResponse
  attr_accessor :exception
  attr_reader :exception
  @bxResponse
  @exception
  def frontend_search_facet_category (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil )
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_autocomplete_property/frontend_search_autocomplete_property","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end
    
    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
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
      @bxResponse = bxClient.getResponse()
      
      #//get the facet responses
      facets = @bxResponse.getFacets()
      
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
      i = 0
      @bxResponse.getHitIds().each do |id|
        @logs.push(i.to_s+": returned id "+id.to_s)
        i += 1
      end

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      @exception = e
    end
  end
end
