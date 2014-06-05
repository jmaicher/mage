class BacklogRepresenter < JSONDecorator
  property :id
  collection :items, class: BacklogItem, decorator: BacklogItemRepresenter,
    getter: lambda { |*| items.includes(:tags, :acceptance_criteria, :backlog).last(5) }
end # BacklogRepresenter
