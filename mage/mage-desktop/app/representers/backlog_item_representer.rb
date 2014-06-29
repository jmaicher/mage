class BacklogItemRepresenter < JSONDecorator
  property :id  
  property :title  
  property :description
  property :estimate, decorator: EstimateOptionDecorator

  collection :taggings, decorator: BacklogItemTaggingRepresenter
  collection :acceptance_criteria, decorator: AcceptanceCriteriaRepresenter

  link :self do
    api_backlog_item_url(represented)
  end

  link :taggings do
    api_backlog_item_taggings_url(represented)
  end
end # BacklogItemRepresenter
