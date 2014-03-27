class BacklogItemRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  property :id  
  property :title  
  property :description

  #property :backlog, decorator: ProductBacklogRepresenter
  collection :taggings, decorator: BacklogItems::TaggingRepresenter

  link :self do
    api_backlog_item_url(represented)
  end

  link :taggings do
    api_backlog_item_taggings_url(represented)
  end

end
