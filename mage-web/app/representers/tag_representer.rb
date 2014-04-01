class TagRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  property :id
  property :name

  link :self do
  end
end
