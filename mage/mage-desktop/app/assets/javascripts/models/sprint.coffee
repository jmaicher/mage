deps = ['ngResource']
module = angular.module('mage.desktop.models.sprint', deps)

module.service 'SprintResource', ($resource) ->
  SprintResource = $resource '/api/sprints/:id', {
    id: '@id'
  }
  SprintResource
# SprintResource

module.service 'Sprint', (SprintResource, SprintBacklog) ->
  construct = (json) ->
    sprint = new SprintResource(json)
    sprint.backlog = SprintBacklog.from_json(json.backlog)
    sprint

  get = (id) ->
    sprint = new SprintResource(
      id: id
    ).get().$promise.then (json) ->
      construct(json)
  
  from_json = (json) ->
    sprint = construct(json)

  return {
    get: get
    from_json: from_json
  }
# SprintBacklog

