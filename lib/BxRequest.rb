class BxRequest
#	require 'BxSortFields'
	require 'p13n_types'
	

    def initialize(language, choiceId, max=10, min=0)
    	@language, @groupBy, @choiceId, @min, @max, @withRelaxation , @indexId ,	@requestMap , returnFields = Array.new
		@offset = 0
		@queryText = ""
		@bxFacets = nil
		@bxSortFields = nil
		@bxFilters = Array.new
		@orFilters = false
	    @hitsGroupsAsHits = nil
	    @groupFacets = nil
	    @requestContextParameters = Array.new()
    	if (choiceId == '')
			raise  'BxRequest created with null choiceId'
		end
		@language = language
		@choiceId = choiceId
		@min = Float(min)
		@max = Float(max)
		if(@max == 0) 
			@max = 1
		end
		@withRelaxation = choiceId == 'search'
    end
	
	def getWithRelaxation

		return self.withRelaxation
		
	end

	def setWithRelaxation(withRelaxation)
		self.withRelaxation = withRelaxation
	end

	def getReturnFields

		return self.returnFields
		
	end

	def setReturnFields(returnFields)
		
		self.returnFields  = returnFields 

	end

	def getOffset
		return self.offset
	end

	def setOffset(offset)
		self.offset = offset
	end
	def getQuerytext
		return self.queryText
	end
	def setQuerytext(queryText)
		self.queryText = queryText
	end
	def getFacets
		return self.bxFacets
	end
	def setFacets(bxFacets)
		self.bxFacets = bxFacets
	end
	def getSortFields
		return self.bxSortFields
	end
	def setSortFields(bxSortFields)
		self.bxSortFields =bxSortFields
	end
	def getFilters
		filters  = self.bxFilters
		if (self.getFacets())
			self.getFacets().getFilters().each do |filter|
				filters.push(filter)
			end			
		end
		return self.bxFilters		
	end

	def setFilters(bxFilters)
		self.bxFilters = bxFilters
	end

	def addFilter(bxFilter)
		self.bxFilters[bxFilter.getFieldName()] = bxFilter
	end

	def getOrFilters

		return self.orFilters
		
	end
	def setOrFilters(orFilters)
		return self.orFilters = orFilters
	end
	def addSortField(field, reverse = false)
		if(self.bxSortFields == nil) 
			self.bxSortFields = BxSortFields.new
		end
		self.bxSortFields.push(field, reverse)
	end
	def getChoiceId
		return self.choiceId
	end
	def setChoiceId(choiceId)
		self.choiceId = choiceId
	end
	def getMax
		return self.max
	end
	def setMax(max)
		self.max = max
	end
	def getMin
		return self.min
	end
	def setMin(min)
		self.min = min
	end
	def getIndexId
		return self.indexId
	end
	def setIndexId(indexId)
		self.indexId = indexId
		self.contextItems.each do |k, contextItem|
			if contextItem.indexId == nil
				self.contextItems[k].indexId = indexId
			end
		end
	end

	def setDefaultIndexId(indexId)
		if self.indexId== nil
			self.setIndexId(indexId)
		end
	end
	def setDefaultRequestMap(requestMap)
		if self.requestMap == nil
			self.requestMap = requestMap
		end
	end
	def getLanguage
		return self.language
	end
	def setLanguage(language)
		self.language = language
	end
	def getGroupBy
		return self.groupBy
	end
	def setGroupBy(groupBy)
		self.groupBy = groupBy
	end
	def setHitsGroupsAsHits(groupsAsHits)
		self.hitsGroupsAsHits = groupsAsHits
	end
	def setGroupFacets(groupFacets)
		self.groupFacets = groupFacets
	end
	def getSimpleSearchQuery
		searchQuery  = SimpleSearchQuery()
		searchQuery.indexId = getIndexId()
		searchQuery.language = getLanguage()
		searchQuery.returnFields = getReturnFields()
		searchQuery.offset = getOffset()
		searchQuery.hitCount = getMax()
		searchQuery.queryText = getQueryText()
		searchQuery.groupFacets = (self.groupFacets == nil ) ? false : self.groupFacets
		searchQuery.groupBy = self.groupBy
		if self.hitsGroupsAsHits != nil
			searchQuery.hitsGroupsAsHits = self.hitsGroupsAsHits
		end
		if getFilters().length >0
			searchQuery.filters = Array.new
			getFilters().each do |filter|
				searchQuery.filters.push(filter.getThriftFilter())
			end
		end
		searchQuery.orFilters = getOrFilters()
		if (getFacets()) 
			searchQuery.facetRequests = getFacets().getThriftFacets()
		end
		if(getSortFields()) 
			searchQuery.sortFields = getSortFields().getThriftSortFields()
		end
		return $searchQuery;
	end
	contextItems = Array.new 
	def setProductContext(fieldName, contextItemId, role = 'mainProduct', relatedProducts = Array.new() , relatedProductField = 'id')
		contextItem = new ContextItem()
		contextItem.indexId = getIndexId()
		contextItem.fieldName = fieldName
		contextItem.contextItemId = contextItemId
		contextItem.role = role
		contextItems[] = contextItem
		addRelatedProducts(relatedProducts, relatedProductField)
	end
	def setBasketProductWithPrices(fieldName, basketContent, role = 'mainProduct', subRole = 'mainProduct', relatedProducts = Array.new() , relatedProductField='id')
		if (basketContent != false && basketContent.length > 0) 
			
			# Sort basket content by price
			basketContent.sort_by { |item| item.price }
			basketItem = basketContent.shift
			
			contextItem = new ContextItem()
			contextItem.indexId = getIndexId()
			contextItem.fieldName = fieldName
			contextItem.contextItemId = basketItem['id']
			contextItem.role = role
			contextItems.push(contextItem)
			basketContent.each do |basketItem| 
				contextItem = new ContextItem()
				contextItem.indexId = getIndexId()
				contextItem.fieldName = fieldName
				contextItem.contextItemId = basketItem['id']
				contextItem.role = $subRole
				contextItems.push(contextItem)
			end
		end
		addRelatedProducts(relatedProducts, relatedProductField)
	end

	def addRelatedProducts(relatedProducts, relatedProductField='id') 
        relatedProducts.each do |productId , related| 
            key = "bx_{"+self.choiceId+"}_"+productId
            self.requestContextParameters[key] = related
        end
    end

    def getContextItems 
		return self.contextItems
	end
	
	def getRequestContextParameters
		return self.requestContextParameters
	end
	
	def retrieveHitFieldValues(item, field, items, fields) 
		return Array.new 
	end
end