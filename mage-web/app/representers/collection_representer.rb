class CollectionRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  # make it dynamic :-)
  collection :items, class: BacklogItemTagging, decorator: BacklogItems::TaggingRepresenter 
end
