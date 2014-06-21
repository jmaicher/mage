deps = ['ngResource']
module = angular.module('mage.desktop.models.product_backlog', deps)

module.service 'ProductBacklogResource', ($resource) ->
  ProductBacklogResource = $resource '/api/backlog'
  ProductBacklogResource
# ProductBacklogResource

module.service 'ProductBacklog', (ProductBacklogResource) ->
  
  get = ->
    backlog = ProductBacklogResource.get().$promise

  return {
    get: get
  }

# ProductBacklog
