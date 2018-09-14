class FrontendRecommendationsSimilarComplementaryController < ApplicationController
  attr_accessor :choiceIdSimilar
  attr_reader :choiceIdSimilar
  attr_accessor :choiceIdComplementary
  attr_reader :choiceIdComplementary
  attr_accessor :bxResponse
  attr_reader :bxResponse
  attr_accessor :exception
  attr_reader :exception
  @choiceIdSimilar
  @choiceIdComplementary
  @bxResponse
  @exception
  def frontend_recommendations_similar_complementary(account = "csharp_unittest", password ="csharp_unittest", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil)
    require 'json'
    require 'BxClient'
    require 'BxRecommendationRequest'
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_recommendations_similar_complementary/frontend_recommendations_similar_complementary","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end
    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request, params)
    bxClient.setCookieContainer(cookies)
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      @choiceIdSimilar = "similar" #the recommendation choice id (standard choice ids are: "similar" => similar products on product detail page, "complementary" => complementary products on product detail page, "basket" => cross-selling recommendations on basket page, "search"=>search results, "home" => home page personalized suggestions, "category" => category page suggestions, "navigation" => navigation product listing pages suggestions)
      @choiceIdComplementary = "complementary"
      itemFieldId = "id" # the field you want to use to define the id of the product (normally id, but could also be a group id if you have a difference between group id and sku)
      itemFieldIdValue = "1940" #the product id the user is currently looking at
      hitCount = 10 #a maximum number of recommended result to return in one page

      #//create similar recommendations request
      bxRequestSimilar = BxRecommendationRequest.new(language, @choiceIdSimilar, hitCount)
      #//indicate the product the user is looking at now (reference of what the recommendations need to be similar to)
      bxRequestSimilar.setProductContext(itemFieldId, itemFieldIdValue)
      #//add the request
      bxClient.addRequest(bxRequestSimilar)


      #//create complementary recommendations request
      bxRequestComplementary = BxRecommendationRequest.new(language, @choiceIdComplementary, hitCount)
      #//indicate the product the user is looking at now (reference of what the recommendations need to be similar to)
      bxRequestComplementary.setProductContext(itemFieldId, itemFieldIdValue)
      #//add the request
      bxClient.addRequest(bxRequestComplementary)

      #//make the query to Boxalino server and get back the response for all requests (make sure you have added all your requests before calling getResponse; i.e.: do not push the first request, then call getResponse, then add a new request, then call getResponse again it wil not work; N.B.: if you need to do to separate requests call, then you cannot reuse the same instance of BxClient, but need to create a new one)
      @bxResponse = bxClient.getResponse()

      #//loop on the recommended response hit ids and print them
      @logs.push("recommendations of similar items:")
      i = 0
      @bxResponse.getHitIds(@choiceIdSimilar).each do |iid|
        @logs.push(i.to_s + ": returned id " + iid.to_s )
        i += 1
      end
      @logs.push("")

      #//retrieve the recommended responses object of the complementary request
      @logs.push("recommendations of complementary items:")
      #//loop on the recommended response hit ids and print them
      i = 0
      @bxResponse.getHitIds(@choiceIdComplementary).each do |iid|
        @logs.push(i.to_s+": returned id "+iid.to_s)
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
