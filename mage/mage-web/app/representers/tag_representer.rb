class TagRepresenter < JSONDecorator
  property :id
  property :name

  link :self do
  end
end # TagRepresenter
