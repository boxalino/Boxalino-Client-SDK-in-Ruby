class FrontendParametrizedRequestController < ApplicationController
  def frontend_parametrized_request (account = "csharp_unittest", password ="csharp_unittest", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil)
  	require 'json'
    require 'BxClient'
    require 'BxParametrizedRequest'
    #required parameters you should set for this example to work
    @account = account # your account name
    @password = password # your account password
    @host =  bxHost
    @exception = exception
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    #@isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    if(!mockRequest.nil?)
      request = mockRequest
    else
      request = ActionDispatch::Request.new({"url"=>"/frontend_parametrized_request/frontend_parametrized_request","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end
    bxClient =BxClient.new(@account, @password, @domain ,  @isDev, @host, request)
    bxClient.setCookieContainer(cookies)
    begin

      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      choiceId = "productfinder" #the recommendation choice id (standard choice ids are: "similar" => similar products on product detail page, "complementary" => complementary products on product detail page, "basket" => cross-selling recommendations on basket page, "search"=>search results, "home" => home page personalized suggestions, "category" => category page suggestions, "navigation" => navigation product listing pages suggestions)
      hitCount = 10 #a maximum number of recommended result to return in one page
      requestWeightedParametersPrefix = "bxrpw_"
      requestFiltersPrefix = "bxfi_"
      requestFacetsPrefix = "bxfa_"
      requestSortFieldPrefix = "bxsf_"
      requestReturnFieldsName= "bxrf"
      
      bxReturnFields = "id" #the list of fields which should be returned directly by Boxalino, the others will be retrieved through a call-back function
      getItemFieldsCB = "getItemFieldsCB"
      
      #//create the request and set the parameter prefix values
      bxRequest = BxParametrizedRequest.new(language, choiceId, hitCount, 0, bxReturnFields, getItemFieldsCB)
      bxRequest.setRequestWeightedParametersPrefix(requestWeightedParametersPrefix)
      bxRequest.setRequestFiltersPrefix(requestFiltersPrefix)
      bxRequest.setRequestFacetsPrefix(requestFacetsPrefix)
      bxRequest.setRequestSortFieldPrefix(requestSortFieldPrefix)
      
      bxRequest.setRequestReturnFieldsName(requestReturnFieldsName)
      
      #//add the request
      bxClient.addRequest(bxRequest)
      # //make the query to Boxalino server and get back the response for all requests
      bxResponse = bxClient.getResponse()
      @logs.push("<h3>weighted parameters</h3>")
      bxRequest.getWeightedParameters().each  do |fieldName , fieldValues|
        fieldValues.each do |fieldValue , weight|
          @logs.push(fieldName+": "+fieldValue+": "+weight)
        end
      end
      @logs.push("..")

      @logs.push("<h3>filters</h3>")
      if(!bxRequest.getFilters().nil?)
        bxRequest.getFilters().each do |bxFilter|
          @logs.push(bxFilter.getFieldName() + ": " + bxFilter.getValues().join(',') + " :" + bxFilter.isNegative())
        end
      end
      @logs.push("..")

      @logs.push("<h3>facets</h3>")
      bxFacets = bxRequest.getFacets()
      bxFacets.getFieldNames().each do |fieldName|
        @logs.push(fieldName+": " + bxFacets.getSelectedValues(fieldName).join(','))
      end
      @logs.push("..")

      @logs.push("<h3>sort fields</h3>")
      bxSortFields = bxRequest.getSortFields()
      bxSortFields.getSortFields().each do |fieldName|
        @logs.push(fieldName+": " + bxSortFields.isFieldReverse(fieldName))
      end
      @logs.push("..")

      #//loop on the recommended response hit ids and print them
      @logs.push("<h3>results</h3>")
      @logs.push(bxResponse.toJson(bxRequest.getAllReturnFields()))

      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      @exception = e
    end
  end
end
