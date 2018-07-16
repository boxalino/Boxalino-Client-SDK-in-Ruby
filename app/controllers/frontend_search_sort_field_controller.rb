class FrontendSearchSortFieldController < ApplicationController
  attr_accessor :bxResponse
  attr_reader :bxResponse
  attr_accessor :sortField
  attr_reader :sortField
  attr_accessor :exception
  attr_reader :exception
  @bxResponse
  @sortField
  @exception
  def frontend_search_sort_field (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil )
  	require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_sort_field/frontend_search_sort_field","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end
    
    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
    bxClient.setCookieContainer(cookies)
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      @sortField = "title" #sort the search results by this field - IMPORTANT: you need to put "products_" as a prefix to your field name except for standard fields: "title", "body", "discountedPrice", "standardPrice"
      sortDesc = true #sort in an ascending / descending way

      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      
      #//add a sort field in the provided direction
      bxRequest.addSortField(@sortField, sortDesc)
      
      #//set the fields to be returned for each item in the response
      bxRequest.setReturnFields([@sortField])
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      @bxResponse = bxClient.getResponse()
      
      #//loop on the search response hit ids and print them
      @bxResponse.getHitFieldValues([@sortField]).each do |id , fieldValueMap|
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
      @exception = e
    end
  end
end
