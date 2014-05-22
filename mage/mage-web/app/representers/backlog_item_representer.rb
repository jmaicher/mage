class BacklogItemRepresenter < JSONDecorator
  property :id  
  property :title  
  property :description

  collection :taggings, decorator: BacklogItemTaggingRepresenter

  link :self do
    api_backlog_item_url(represented)
  end

  link :taggings do
    api_backlog_item_taggings_url(represented)
  end
end # BacklogItemRepresenter
