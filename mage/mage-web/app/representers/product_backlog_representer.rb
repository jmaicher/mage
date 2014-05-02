class ProductBacklogRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL
  
  collection :items, class: BacklogItem, decorator: BacklogItemRepresenter

  link :self do
    api_backlog_url
  end
end
