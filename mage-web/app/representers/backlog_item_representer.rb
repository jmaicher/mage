class BacklogItemRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL
  
  property :title  
  property :description

  #property :backlog, decorator: ProductBacklogRepresenter

  link :self do
    "NOT IMPLEMENTED"
  end
end
