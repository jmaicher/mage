class SprintRepresenter < JSONDecorator
  property :id
  property :goal
  property :start_date
  property :end_date
  
  property :backlog, decorator: SprintBacklogRepresenter
end # SprintRepresenter
