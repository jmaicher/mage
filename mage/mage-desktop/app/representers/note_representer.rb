class NoteRepresenter < JSONDecorator
  include ActionView::Helpers::DateHelper

  property :id
  property :title
  property :description
  property :image_url, getter: lambda { |*| image.url unless image.nil? }
  property :author, decorator: Embedded::UserRepresenter
  property :created_at, getter: lambda { |*| ActionController::Base.helpers.time_ago_in_words(created_at) }

  link :self do
  end
end # NoteRepresenter
