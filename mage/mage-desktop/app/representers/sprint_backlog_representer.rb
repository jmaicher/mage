class SprintBacklogRepresenter < JSONDecorator
  collection :items, class: BacklogItem, decorator: SprintBacklogItemRepresenter
end # SprintBacklogRepresenter
