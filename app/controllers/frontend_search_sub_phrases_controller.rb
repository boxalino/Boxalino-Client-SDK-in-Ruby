class FrontendSearchSubPhrasesController < ApplicationController
  attr_accessor :bxResponse
  attr_reader :bxResponse
  attr_accessor :exception
  attr_reader :exception
  @bxResponse
  @exception
  def frontend_search_sub_phrases (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil )
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_sub_phrases/frontend_search_sub_phrases","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request, params)
    bxClient.setCookieContainer(cookies)
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      queryText = "women pack" # a search query
      hitCount = 10 #a maximum number of search result to return in one page

      #//create search request
      bxRequest = BxSearchRequest.new(language, queryText, hitCount)

      #//add the request
      bxClient.addRequest(bxRequest)

      #//make the query to Boxalino server and get back the response for all requests
      @bxResponse = bxClient.getResponse()

      #//check if the system has generated sub phrases results
      if(@bxResponse.areThereSubPhrases())
        @logs.push("No results found for all words in " + queryText + ", but following partial matches were found:")
        if(!@bxResponse.getSubPhrasesQueries().nil?)
          @bxResponse.getSubPhrasesQueries().each do |subPhrase|
            @logs.push("Results for \"" + subPhrase + "\" (" + @bxResponse.getSubPhraseTotalHitCount(subPhrase).to_s + " hits):")
            #//loop on the search response hit ids and print them
            i=-1
            @bxResponse.getSubPhraseHitIds(subPhrase).each do |iid|
              i += 1
              @logs.push(i.to_s + ": returned id " + iid.to_s)
            end
            @logs.push('')
          end
        end
      else
        #//loop on the search response hit ids and print them
        i=-1
        @bxResponse.getHitIds().each do |iid|
          i += 1
          @logs.push(i.to_s + ": returned id " + iid.to_s)

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
