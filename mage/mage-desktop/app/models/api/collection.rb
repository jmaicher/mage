class API::Collection
  attr_accessor :items, :links

  def initialize(items, links = {})
    @items = items
    @links = links
  end
end # API::Collection
