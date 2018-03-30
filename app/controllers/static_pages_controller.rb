class StaticPagesController < ApplicationController
  def backend_data_basic
  	#require 'p13n_service'
  	require 'BxAutocompleteRequest'
  	sparky = BxAutocompleteRequest.new(1,2,3)
  	@message = "Hello, how are you today?"
  end
end
