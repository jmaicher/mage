class Embedded::BacklogItemRepresenter < JSONDecorator
  property :id  
  property :title  
  property :description

  link :self do
    api_backlog_item_url(represented)
  end
end # Embedded::BacklogItemRepresenter
