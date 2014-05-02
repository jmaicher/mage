class IdeaRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  property :id
  property :title
  property :description
  property :author_id

  link :self do
  end
end
