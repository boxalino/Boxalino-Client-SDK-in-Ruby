class FrontendSearchReturnFieldsController < ApplicationController
  attr_accessor :bxResponse
  attr_reader :bxResponse
  attr_accessor :fieldNames
  attr_reader :fieldNames
  attr_accessor :exception
  attr_reader :exception
  @bxResponse
  @fieldNames
  @exception
  def frontend_search_return_fields (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil )
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_facet/frontend_search_facet","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end
    
    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women" # a search query
      hitCount = 10 #a maximum number of search result to return in one page
      
      @fieldNames = ["products_color"] #//IMPORTANT: you need to put "products_" as a prefix to your field name except for standard fields: "title", "body", "discountedPrice", "standardPrice"
      
      #//create search request
      bxRequest =  BxSearchRequest.new(language, queryText, hitCount)
      
      #//set the fields to be returned for each item in the response
      bxRequest.setReturnFields(fieldNames)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      
      #//make the query to Boxalino server and get back the response for all requests
      @bxResponse = bxClient.getResponse()

      #//loop on the search response hit ids and print them
      @bxResponse.getHitFieldValues(fieldNames).each do |id , fieldValueMap|
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
      @exception = e
    end
  end
end
