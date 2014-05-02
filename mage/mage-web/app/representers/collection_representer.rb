class CollectionRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  collection :items

  link :self do
    represented.links.fetch(:self, "")
  end
end
