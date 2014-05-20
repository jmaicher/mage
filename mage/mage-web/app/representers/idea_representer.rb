class IdeaRepresenter < JSONDecorator
  property :id
  property :title
  property :description
  property :author_id

  link :self do
  end
end # IdeaRepresenter
