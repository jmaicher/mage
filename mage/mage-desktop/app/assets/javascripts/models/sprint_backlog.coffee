deps = ['ngResource']
module = angular.module('mage.desktop.models.sprint_backlog', deps)

module.service 'SprintBacklogResource', ($resource) ->
  SprintBacklogResource = $resource '/api/sprints/:sprint_id/backlog/items', {
    sprint_id: '@sprint_id'
  }
  SprintBacklogResource
# SprintBacklogResource

module.service 'SprintBacklog', (SprintBacklogResource, SprintBacklogItem) ->
  construct = (json) ->
    backlog = new SprintBacklogResource(json)
    backlog.items = backlog.items.map (json_item) -> SprintBacklogItem.from_json(json_item)
    backlog
  
  get = (sprint) ->
    backlog = new SprintBacklogResource(
      sprint_id: sprint.id
    ).get().$promise

  from_json = (json) ->
    backlog = construct(json)

  return {
    get: get
    from_json: from_json
  }
# SprintBacklog

module.service 'SprintBacklogItemResource', ($resource) ->
  SprintBacklogItemResource = $resource '/api/sprints/:sprint_id/backlog/items', {
    sprint_id: '@sprint_id'
  }

  SprintBacklogItemResource
# SprintBacklogItemResource

module.service 'SprintBacklogItem', (SprintBacklogItemResource, Task) ->
  construct = (json) ->
    item = new SprintBacklogItemResource (json)
    item.tasks = item.tasks.map (json_task) -> Task.from_json(json_task)
    item
  
  create = (sprint, backlog_item) ->
    new SprintBacklogItemResource(
      sprint_id: sprint.id,
      backlog_item_id: backlog_item.id
    ).$save()

  from_json = (json) ->
    item = construct(json)

  return {
    create: create
    from_json: from_json
  }
# SprintBacklogItem

module.service 'TaskResource', ($resource) ->
  TaskResource = $resource '/api/sprints/:sprint_id/backlog/items/:backlog_item_id/tasks/:id', {
    sprint_id: '@sprint_id'
    backlog_item_id: '@backlog_item_id'
    id: '@id'
  }, {
    update: { method: 'PUT' }
  }

  TaskResource
# TaskResource

module.service 'Task', (TaskResource) ->
  construct = (json) ->
    task = new TaskResource (json)
    task

  build = (sprint, backlog_item) ->
    new TaskResource(
      sprint_id: sprint.id,
      backlog_item_id: backlog_item.id
    )
  
  create = (sprint, backlog_item) ->
    build(sprint, backlog_item).$save()

  from_json = (json) ->
    task = construct(json)

  return {
    build: build
    create: create
    from_json: from_json
  }
# Task
