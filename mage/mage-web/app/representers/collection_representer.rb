class CollectionRepresenter < JSONDecorator
  collection :items, extend: lambda { |item, *|
    # Get representer by naming convention, extract to PolymorphicExtender?
    Rails.const_get("#{item.class.to_s}Representer")
  }

  link :self do
    represented.links.fetch(:self, "")
  end
end # CollectionRepresenter
