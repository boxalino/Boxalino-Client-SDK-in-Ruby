class FrontendSearchDebugRequestController < ApplicationController
  attr_accessor :bxClient
  attr_reader :bxClient
  attr_accessor :exception
  attr_reader :exception
  @bxClient
  @exception
  def frontend_search_debug_request (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil )
    require 'json'
    require 'BxClient'
    require 'BxSearchRequest'
    j = ActiveSupport::JSON
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
    offset = 0
    @bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
    #To Check Below Line
    #bxClient.setRequestMap($_REQUEST);
    begin

      language = "de" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "home" #the recommendation choice id (standard choice ids are: "similar" => similar products on product detail page, "complementary" => complementary products on product detail page, "basket" => cross-selling recommendations on basket page, "search"=>search results, "home" => home page personalized suggestions, "category" => category page suggestions, "navigation" => navigation product listing pages suggestions)
      hitCount = 10 #a maximum number of recommended result to return in one page

      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)
      @bxClient.addRequestContextParameter("start_time" , "2018-01-01")
      @bxClient.addRequestContextParameter("end_time" , "2018-01-01")

      bxRequest.setOffset(offset)
      #//add the request
      @bxClient.addRequest(bxRequest)

      #//make the query to Boxalino server and get back the response for all requests
       bxResponse = @bxClient.getResponse()

      #//print the request object which is sent to our server (please provide it to Boxalino in all your support requests)

      @message = j.encode(@bxClient.getThriftChoiceRequest())

    rescue Exception => e

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      @exception = e
    end
  end
end
