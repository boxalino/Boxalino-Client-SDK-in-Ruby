class FrontendBatchController < ApplicationController
  attr_accessor :bxResponse
  attr_reader :bxResponse
  attr_accessor :exception
  attr_reader :exception
  @bxResponse
  @exception

  def frontend_batch(account = "dana_magento1_03", password ="dana_magento1_03")
    require 'json'
    require 'BxClient'
    require 'BxBatchClient'
    require 'BxBatchResponse'
    require 'BxBatchRequest'
    #required parameters you should set for this example to work
    @account = account # your account name
    @password = password # your account password
    @domain = "boxalino.com" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    begin
      language = "de"
      hitCount = 5
      choice_id = "home"
      profileIds = [27, 71]


      bxClient =BxBatchClient.new(@account, @password, @domain)
      bxRequest = BxBatchRequest.new(language,choice_id)
      bxRequest.setMax(hitCount)
      bxRequest.setGroupBy("id")
      bxRequest.setOffset(0)
      bxRequest.setProfileIds(profileIds)

      bxClient.setRequest(bxRequest)

      @bxResponse = bxClient.getBatchChooseResponse

      @logs = Array.new
      # ### showing the output of a search request

      #response: {customer_id=> [{field1=>value, field2=>value,..}, {field1=>value, field2=>value, ..},..], customer_id=>[{}, {}, {}]}
      search_result = @bxResponse.getHitFieldValueForProfileIds
      search_result.each do |id, productMaps|
        entity = "<h3>"+id.to_s+"</h3>"
        count = 1
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

      #response: [customer_id=>[product1_id, product2_id, product3_id], ...]
      search_products = @bxResponse.getHitIds
      search_products.each do |id, values|
        entity = "<h3>"+id.to_s+"</h3>" + values.to_s
        @logs.push(entity)
      end

      @message = @logs.join("<br/>")

    rescue Exception => e
      @message =  e
      @exception = e.backtrace
    end
  end

end
