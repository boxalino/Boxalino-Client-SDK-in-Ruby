class StaticPagesController < ApplicationController
  def backend_data_basic
    #require 'p13n_service'
    # require 'BxAutocompleteRequest'
    # sparky = BxAutocompleteRequest.new(1,2,3)
    # @message = "Hello, how are you today?"
    require 'builder'
  sources = ['test','developer']
  sourcesR = ['test'=>'developer']
     xml = Builder::XmlMarkup.new( :target => stdout, :indent => 2 )
      #languages
      tests ="MyCustomTag"
      xml.languages do 
          getLanguages().each do | lang |
              xml.language(  'id' => lang )
          end
      end
    xyz=''
      xml.root do 
        #containers
        xml.containers do 
            sources.each do | containerName , containerSources |
                xml.container(  'id' => containerName, 'type' => containerName )  do
                  xml.sources do 
                    xml.source123('id'=>"item_vals") do |dd|
                     xyz = dd 
                    end
                    xyz.tag!('ddd', 'rr'=>'ddd',sourcesR )
                  end
                end
          #      xml.sources = container->addChild('sources');
            end
            
        end
        xml.tag!(tests)
      end
    # @message = "Hello, how are you today?"

  end
  def getLanguages
    return ['en','ar']
  end
end
