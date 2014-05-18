class CollectionRepresenter < JSONDecorator
  collection :items

  link :self do
    represented.links.fetch(:self, "")
  end
end # CollectionRepresenter
