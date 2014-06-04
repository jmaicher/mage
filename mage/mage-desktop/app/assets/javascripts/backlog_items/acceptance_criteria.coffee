module = angular.module('mage.desktop.backlog_items.acceptance_criteria', [])

module.service 'AcceptanceCriteriaResource', ($resource) ->
  AcceptanceCriteriaResource = $resource "/api/backlog_items/:backlog_item_id/acceptance_criteria/:id", {
    backlog_item_id: '@backlog_item_id'
    id: '@id'
  }, {
    update: { method: 'PUT' }
  }

  AcceptanceCriteriaResource
# AcceptanceCriteriaResource


module.directive 'acceptanceCriteria', ->
  restrict: 'E'
  templateUrl: 'backlog_items/acceptance_criteria.html'
  controller: ($scope, BootstrappedData, AcceptanceCriteriaResource) ->
    $scope.acceptanceCriteria = BootstrappedData.backlog_item.acceptance_criteria.map (params) ->
      new AcceptanceCriteriaResource(params)

    $scope.new = ->
      criteria = new AcceptanceCriteriaResource
        isNew: true
        backlog_item_id: BootstrappedData.backlog_item.id
      $scope.acceptanceCriteria.push(criteria)
# acceptanceCriteria


module.directive 'criteria', ->
  restrict: 'E'
  replace: true
  templateUrl: 'backlog_items/criteria.html'
  scope:
    criteria: '=criteria'
  link: (scope, element) ->
    scope.remove = ->
      element.remove()
    return
  controller: ($scope) ->
    $scope.showForm = $scope.isNew = !!$scope.criteria.isNew
    delete $scope.criteria.isNew

    $scope.edit = ->
      $scope.showForm = true

    $scope.onFormSuccess = ->
      $scope.showForm = false
      $scope.isNew = false
    
    $scope.onFormCancel = ->
      $scope.showForm = false
      $scope.remove() if $scope.isNew
      return
# criteria


module.directive 'criteriaForm', ->
  restrict: 'E'
  templateUrl: 'backlog_items/acceptance_criteria_form.html'
  scope:
    master: '=criteria'
    isNew: '='
    notifySuccess: '&onSuccess'
    notifyCancel: '&onCancel'
  link: (scope, element, attr) ->
    input = element.find('input[type=text]')
    input.on 'blur', -> scope.$apply ->
      if !scope.isNew && !scope.loading && scope.criteriaForm.$pristine
        scope.notifyCancel()
    return
  controller: ($scope) ->
    # use copy for form manipulation
    $scope.criteria = angular.copy($scope.master)

    onSuccess = (criteria) ->
      # update master => propagate changes to parent scope
      angular.extend $scope.master, criteria
      $scope.notifySuccess()

    onFailure = (response) ->
      console.log(response.data)
      $scope.errors = response.data

    $scope.submit = ->
      $scope.errors = []
      $scope.criteriaForm.$setPristine(true)
      method = if $scope.isNew then '$save' else '$update'

      $scope.loading = true
      $scope.criteria[method]().then(onSuccess, onFailure)
        .finally -> $scope.loading = false

    $scope.cancel = ->
      $scope.notifyCancel()
# criteriaForm


module.directive 'autoFocus', ->
  restrict: 'A'
  link: (scope, element, attr) ->
    element[0].focus()
    return
# autoFocus 
