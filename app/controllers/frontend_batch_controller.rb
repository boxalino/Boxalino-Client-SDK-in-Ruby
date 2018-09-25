class FrontendBatchController < ApplicationController
  attr_accessor :bxResponse
  attr_reader :bxResponse
  attr_accessor :exception
  attr_reader :exception
  @bxResponse
  @exception

  def frontend_batch(account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", exception = nil, bxHost = "cdn.bx-cloud.com",mockRequest = nil )
    require 'json'
    require 'BxBatchClient'
    require 'BxBatchResponse'
    require 'BxBatchRequest'
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
      request = ActionDispatch::Request.new({"url"=>"/frontend_search_facet_category/frontend_search_facet_category","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    end
    begin
      language = "en"
      hitCount = 5
      curent_date = DateTime.now.strftime("%F")
      choice_id = 'home'
      field_names = ["title", "discountedPrice"] #a list of field names to be returned such as product title, price, image URL, etc
      profileIds = ["14589", "5268", "36547"]


      # # add context to the client
      bxClient =BxBatchClient.new(@account, @password, @domain , @isDev, @apiKey, @apiSecret)
      bxClient.addRequestContextParameter("current_date" , curent_date)
      bxClient.addRequestContextParameter("dev_bx_disp" , true)

      bxRequest = BxBatchRequest.new(language,choice_id)
      bxRequest.setUseSameChoiceInquiry(true)
      bxRequest.setMax(hitCount)
      bxRequest.setReturnFields(field_names)
      bxRequest.setOffset(0)
      bxRequest.setProfileIds(profileIds)

      bxClient.setRequest(bxRequest)

      @bxResponse = bxClient.getBatchChooseResponse()

      @logs = Array.new
      # ### showing the output of a search request
      search_result = @bxResponse.getHitFieldValueForProfileIds()
      search_result.each do |id, productMaps|
        entity = "<h3>"+id.to_s+"</h3>"
        count = 1;
        productMaps.each do |product|
          product.each do |fieldName ,fieldValues|
            fieldVal = fieldValues.join(',')
            entity = entity + fieldName+ " : " + fieldVal
          end
          entity = entity + " END OF PRODUCT " + count.to_s
          @logs.push(entity)
          count+=1
        end
      end

      @message = @logs.join("<br/>")

    rescue Exception => e
      @message =  e
      @exception = e.backtrace
    end
  end

end
