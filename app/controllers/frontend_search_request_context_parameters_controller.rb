class FrontendSearchRequestContextParametersController < ApplicationController
  attr_accessor :exception
  attr_reader :exception
  @exception
  def frontend_search_request_context_parameters (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil )
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_request_context_parameters/frontend_search_request_context_parameters","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request, params)
    bxClient.setCookieContainer(cookies)
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
      @logs.push("Results for query \"" + queryText + "\" (" + bxResponse.getTotalHitCount().to_s + "):<br>")

      #//loop on the search response hit ids and print them
      i =0
      bxResponse.getHitIds().each do |iid|
        @logs.push(i.to_s+": returned id "+iid)
        i += 1
      end

      @message = @logs.join("<br/>")

    rescue Exception => e

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      @exception = e.backtrace
    end
  end
end
