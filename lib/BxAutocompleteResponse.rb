require 'digest'
class BxAutocompleteResponse
	@response
	@bxAutocompleteRequest
	
	def initialize(response, bxAutocompleteRequest=nil) 
		@response = response
		@bxAutocompleteRequest = bxAutocompleteRequest
	end
	
	def getResponse
		return @response
	end

    def getPrefixSearchHash
        if (getResponse().prefixSearchResult.totalHitCount > 0) 
            hashcode = Digest::MD5.hexdigest getResponse()->prefixSearchResult->queryText
            return hashcode[ 0, 10]
        else 
            return nil
        end
    end
	
	def getTextualSuggestions
		suggestions = Array.new()
		getResponse().hits.each  do |hit|
		    if(suggestions.keys[$hit->suggestion])) continue;
			$suggestions[$hit->suggestion] = $hit->suggestion;
        end
		return $this->reOrderSuggestions($suggestions);
	end
	
	public function suggestionIsInGroup($groupName, $suggestion) {
		$hit = $this->getTextualSuggestionHit($suggestion);
		switch($groupName) {
		case 'highlighted-beginning';
			return $hit->highlighted != "" && strpos($hit->highlighted, $this->bxAutocompleteRequest->getHighlightPre()) === 0;
		case 'highlighted-not-beginning';
			return $hit->highlighted != "" && strpos($hit->highlighted, $this->bxAutocompleteRequest->getHighlightPre()) !== 0;
		default:
			return ($hit->highlighted == "");
		}
	}
	
	public function reOrderSuggestions($suggestions) {
		$queryText = $this->getSearchRequest()->getQueryText();
		
		$groupNames = array('highlighted-beginning', 'highlighted-not-beginning', 'others');
		$groupValues = array();
		
		foreach($groupNames as $k => $groupName) {
			if(!isset($groupValues[$k])) {
				$groupValues[$k] = array();
			}
			foreach($suggestions as $suggestion) {
				if($this->suggestionIsInGroup($groupName, $suggestion)) {
					$groupValues[$k][] = $suggestion;
				}
			}
		}
		
		$final = array();
		foreach($groupValues as $values) {
			foreach($values as $value) {
				$final[] = $value;
			}
		}
		
		return $final;
	}
	
	protected function getTextualSuggestionHit($suggestion) {
		foreach ($this->getResponse()->hits as $hit) {
			if($hit->suggestion == $suggestion) {
				return $hit;
			}
		}
		throw new \Exception("unexisting textual suggestion provided " . $suggestion);
	}
	
	public function getTextualSuggestionTotalHitCount($suggestion) {
		$hit = $this->getTextualSuggestionHit($suggestion);
		return $hit->searchResult->totalHitCount;
	}
	
	public function getSearchRequest() {
		return $this->bxAutocompleteRequest->getBxSearchRequest();
	}
	
	public function getTextualSuggestionFacets($suggestion) {
		$hit = $this->getTextualSuggestionHit($suggestion);
	
		$facets = $this->getSearchRequest()->getFacets();

		if(empty($facets)){
			return null;
		}
		$facets->setSearchResults($hit->searchResult);
		return $facets;
	}
	
	public function getTextualSuggestionHighlighted($suggestion) {
		$hit = $this->getTextualSuggestionHit($suggestion);
		if($hit->highlighted == "") {
			return $suggestion;
		}
		return $hit->highlighted;
	}
	
	public function getBxSearchResponse($textualSuggestion = null) {
		$searchResult = $textualSuggestion == null ? $this->getResponse()->prefixSearchResult : $this->getTextualSuggestionHit($textualSuggestion)->searchResult;
		return new \com\boxalino\bxclient\v1\BxChooseResponse($searchResult, $this->bxAutocompleteRequest->getBxSearchRequest());
	}
	
	public function getPropertyHits($field) {
		foreach ($this->getResponse()->propertyResults as $propertyResult) {
			if ($propertyResult->name == $field) {
				return $propertyResult->hits;
			}
		}
		return array();
	}
	
	public function getPropertyHit($field, $hitValue) {
		foreach ($this->getPropertyHits($field) as $hit) {
			if($hit->value == $hitValue) {
				return $hit;
			}
		}
		return null;
	}
	
	public function getPropertyHitValues($field) {
		$hitValues = array();
		foreach ($this->getPropertyHits($field) as $hit) {
			$hitValues[] = $hit->value;
		}
		return $hitValues;
	}
	
	public function getPropertyHitValueLabel($field, $hitValue) {
		$hit = $this->getPropertyHit($field, $hitValue);
		if($hit != null) {
			return $hit->label;
		}
		return null;
	}
	
	public function getPropertyHitValueTotalHitCount($field, $hitValue) {
		$hit = $this->getPropertyHit($field, $hitValue);
		if($hit != null) {
			return $hit->totalHitCount;
		}
		return null;
	}
	
end