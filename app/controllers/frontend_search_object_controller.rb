class FrontendSearchObjectController < ApplicationController
  attr_accessor :bxResponse
  attr_reader :bxResponse
  attr_accessor :exception
  attr_reader :exception
  @bxResponse
  @exception
  load 'lib/BxClient.rb'
  load 'lib/BxRequest.rb'
  load 'lib/BxChooseResponse.rb'
  load 'lib/BxFacets.rb'
  load 'lib/reusing_http_client_transport.rb'
  load 'lib/BxAutocompleteResponse.rb'

  def frontend_search_object (account = "boxalino_automated_tests2", password ="boxalino_automated_tests2", bxHost = "cdn.bx-cloud.com")
    require 'json'
    require 'BxClient'
    require 'BxRecommendationRequest'
    require 'BxSearchRequest'
    require 'logger'
    @account = account
    @password = password
    @host =  bxHost
    @exception = exception
    @domain = "mooris.ch"
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?

    request = ActionDispatch::Request.new({"url"=>"/frontend_search_object/frontend_search_object","uri"=>"http://localhost:3000/", "host" => "localhost", "REMOTE_ADDR" => "127.0.0.1", "protocol" => "http"})
    bxClient =BxClient.new(@account, @password, @domain,  @isDev, @host, request)
    begin
      language = "en" # a valid language code (e.g.: "en", "fr", "de", "it", ...)
      hitCount = 10 #a maximum number of recommended result to return in one page
      choice_id = 'search'
      queryText = ""
      selectedValue = nil

      bxRequest = BxSearchRequest.new(language, queryText, hitCount, choice_id)
      bxRequest.setOffset(0)

      #facetsSet = prepare_facets(selectedValue, facetFields)
      facetsSet =  BxFacets.new()
      facetsSet.addPriceRangeFacet(selectedValue)
      facetsSet.addFacet("products_color", selectedValue)

      bxRequest.setFacets(facetsSet)
      bxRequest.setGroupFacets(true)

      bxClient.addRequest(bxRequest)

      bxResponse = bxClient.getResponse()
      facets = bxResponse.getFacets()

      collection = facets.getFacetsAsObjectsCollection("en")
      renderedCollection = render_facets_from_collection(collection, facets)
      @logs.push(renderedCollection)

      @message = @logs.join("<br/>")
    rescue Exception => e
      @message =  e
      @exception = e.backtrace
    end

  end

  def render_facets_from_collection(collection, facets)
    logs = Array.new
    collection.each do |field, facetObject|
      logs.push("----------------------" + field + " - " + facetObject.label + "-----------------------------------")

      if(facetObject.hidden || facetObject.optionValues.nil?)
        logs.push("facet is hidden or has no output")
        return logs
      end
      if(facetObject.icon.nil?)
        icon = ''
      else
        icon = "<i class=\"" + facetObject.icon + "\"></i>"
      end
      logs.push("<div class=\"container\">")
      logs.push("<div class=\"header\">"+ icon.to_s + " <span>"+facetObject.label + "</span></div>")
      logs.push("<div class=\"content\">")
      showedMoreLink = false
      showCounter = facetObject.showCounter
      if(!facetObject.optionValues.nil?)
        facetObject.optionValues.each do |permalink, optionValue|
          if(facetObject.type == "ranged")
            facets.getPriceRanges().each do |fieldValue|
              range = "<a href=\"?bx_price=" + facets.getPriceValueParameterValue(fieldValue) + "\">" + facets.getPriceValueLabel(fieldValue) + "</a> (" + facets.getPriceValueCount(fieldValue).to_s + ")"
              if(facets.isPriceValueSelected(fieldValue))
                range = range+  "<a href=\"?\">[X]</a>"
              end
              logs.push(range)
            end
          else
            facetOption = optionValue
            postfix=""
            if(showCounter)
              hitcount = facetOption.hitCount
              postfix = " (" + hitcount.to_s + ")"
            end
            if(facetOption.selected)
              postfix = postfix + "<a href=\"?\">[X]</a>"
            end
            if(facetOption.icon.nil?)
              facetOption.icon="<M>"
            end
            if(!showedMoreLink && facetOption.hidden)
              showedMoreLink = true
              logs.push("<li class=\"show_more_values\">more values</li>")
            end
            logs.push("<li class=\"additional_values_\"><a href=\"?bx_" + field + "=" + facetOption.stringValue + "\">" +  facetOption.icon + facetOption.label + "</a>"+ postfix +"</li>")
          end
        end
      end

      logs.push("</ul></div></div>")
      logs.join("<br/>")
    end

    return logs
  end

end
