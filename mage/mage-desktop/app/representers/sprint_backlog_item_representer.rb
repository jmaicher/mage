class SprintBacklogItemRepresenter < JSONDecorator
  property :id
  property :title  
  property :description
  
  collection :tasks, decorator: TaskRepresenter
end # SprintBacklogItemRepresenter
