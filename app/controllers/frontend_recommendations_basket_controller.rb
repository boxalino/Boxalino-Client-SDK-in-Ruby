class FrontendRecommendationsBasketController < ApplicationController
  def frontend_recommendations_basket
  	require 'json'
    require 'BxClient'
    require 'BxRecommendationRequest'
    #required parameters you should set for this example to work
    @account = "csharp_unittest"; # your account name
    @password = "csharp_unittest"; # your account password
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @host =  "cdn.bx-cloud.com"

    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      choiceId = "basket" #the recommendation choice id (standard choice ids are: "similar" => similar products on product detail page, "complementary" => complementary products on product detail page, "basket" => cross-selling recommendations on basket page, "search"=>search results, "home" => home page personalized suggestions, "category" => category page suggestions, "navigation" => navigation product listing pages suggestions)
      itemFieldId = "id" # the field you want to use to define the id of the product (normally id, but could also be a group id if you have a difference between group id and sku)
      itemFieldIdValuesPrices = Array.new([{:id=>"1234", :price=>130.5},{:id=>"1940", :price=>10.80}]) #the product ids and their prices that the user currently has in his basket
      hitCount = 10 #a maximum number of recommended result to return in one page

      #//create similar recommendations request
      bxRequest = BxRecommendationRequest.new(language, choiceId, hitCount)

      #//indicate the products the user currently has in his basket (reference of products for the recommendations)
      bxRequest.setBasketProductWithPrices(itemFieldId, itemFieldIdValuesPrices)

      #//add the request
      bxClient.addRequest(bxRequest)

      #//make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()

      #//loop on the recommended response hit ids and print them
      i = 0
      bxResponse.getHitIds().each do | id|
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
