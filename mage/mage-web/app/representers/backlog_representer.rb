class BacklogRepresenter < JSONDecorator
  property :id
  collection :items, class: BacklogItem, decorator: BacklogItemRepresenter
end # BacklogRepresenter
