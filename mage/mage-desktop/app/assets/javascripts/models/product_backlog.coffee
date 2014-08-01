deps = ['ngResource']
module = angular.module('mage.desktop.models.product_backlog', deps)

module.service 'ProductBacklogResource', ($resource) ->
  ProductBacklogResource = $resource '/api/backlog', {}, {
    insert:
      method: 'POST'
      url: '/api/backlog/insert'
  }

  isPrioritized = (item) ->
    !!item.priority

  ProductBacklogResource.prototype.insertAt = (backlog_item_id, priority) ->
    @$insert({
      backlog_item_id: backlog_item_id,
      priority: priority
    })

  ProductBacklogResource.prototype.prioritizedItems = ->
    @items.filter (item) -> isPrioritized(item)

  ProductBacklogResource.prototype.unprioritizedItems = ->
    @items.filter (item) -> !isPrioritized(item)

  ProductBacklogResource
# ProductBacklogResource

module.service 'ProductBacklog', (ProductBacklogResource) ->
  
  get = ->
    backlog = ProductBacklogResource.get().$promise

  from_json = (json) ->
    backlog = new ProductBacklogResource(json)

  return {
    get: get
    from_json: from_json
  }

# ProductBacklog
