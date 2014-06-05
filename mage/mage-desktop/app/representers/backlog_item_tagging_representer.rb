class BacklogItemTaggingRepresenter < Roar::Decorator
  include Roar::Representer::JSON::HAL

  property :id
  property :tag, class: Tag, decorator: TagRepresenter

  link :destroy do
    api_backlog_item_tagging_url(represented.backlog_item_id, represented)
  end
end 
