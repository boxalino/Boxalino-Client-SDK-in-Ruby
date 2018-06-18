class FrontendRecommendationsSimilarController < ApplicationController

	def frontend_recommendations_similar
		require 'json'
	    require 'BxClient'
	    require 'BxRecommendationRequest'
		j = ActiveSupport::JSON
	    #required parameters you should set for this example to work
	    @account = ""; # your account name
	    @password = ""; # your account password
	    @domain = "" # your web-site domain (e.g.: www.abc.com)
	    @logs = Array.new #optional, just used here in example to collect logs
	    @isDev = false #are the data to be pushed dev or prod data?
	    @host =  "cdn.bx-cloud.com"
	    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
	    offset = 0
	    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
	    begin

			language = "de" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
			choiceId = "home" #the recommendation choice id (standard choice ids are: "similar" => similar products on product detail page, "complementary" => complementary products on product detail page, "basket" => cross-selling recommendations on basket page, "search"=>search results, "home" => home page personalized suggestions, "category" => category page suggestions, "navigation" => navigation product listing pages suggestions)
			hitCount = 10 #a maximum number of recommended result to return in one page

			#//create similar recommendations request
			bxRequest = BxRecommendationRequest.new(language, choiceId, hitCount)

			bxClient.addRequestContextParameter("start_time" , "2018-01-01" )
			bxClient.addRequestContextParameter("end_time" , "2018-01-01")
			bxClient.addToRequestMap('dev_bx_disp',[true])
			bxRequest.setOffset(offset)
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
