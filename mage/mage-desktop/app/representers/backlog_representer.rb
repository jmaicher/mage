class BacklogRepresenter < JSONDecorator

  property :id
  collection :items, class: BacklogItem, decorator: BacklogItemRepresenter,
    getter: lambda { |*| ordered_items }
end # BacklogRepresenter
