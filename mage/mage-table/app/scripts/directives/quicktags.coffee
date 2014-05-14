"use strict"

app = angular.module('mageTable')

app.directive 'quicktagMenu', () ->
  restrict: 'E'
  transclude: true
  templateUrl: '/views/quicktag-menu.html'
  link: ($scope, $element, attrs) ->
    $element.find('a.quicktag-menu-trigger').on 'pointerdown pointerup tap', (evt) ->
      evt.stopPropagation() if evt.type is 'tap'
      switch evt.type
        when 'pointerdown', 'mousedown'
          $scope.$apply -> $scope.opened = true
        when 'pointerup', 'mouseup'
          $scope.$apply -> $scope.opened = false
      return

  controller: ($scope) ->
    $scope.opened = false


app.directive 'quicktag', () ->
  restrict: 'E'
  replace: true
  scope:
    item: '='
    quicktag: '='
  templateUrl: '/views/quicktag.html'
  link: ($scope, $element, attrs) ->
    $element.find('a').on 'pointerup mouseup tap', (evt) ->
      $scope.$apply -> $scope.toggle()
      evt.stopPropagation() if evt.type is 'tap'
      return

  controller: ($scope, $timeout, $http, BacklogItemTaggingMapper, Hosts) ->
    tag = $scope.quicktag.name
    tagging = $scope.item.find_tagging(tag)
    $scope.has_tag = !!tagging
    $scope.enabled = true

    $scope.toggle = ->
      $scope.enabled = false
      
      unless $scope.has_tag
        url = "#{Hosts.api}/backlog_items/#{$scope.item.id}/taggings"
        $http.post(url, {
          tag: {
            name: tag
          }
        }).then (resp) ->
          tagging = BacklogItemTaggingMapper.from_json(resp.data)
          $scope.enabled = true
          $scope.has_tag = true
      else
        url = "#{Hosts.api}/backlog_items/#{$scope.item.id}/taggings/#{tagging.id}"
        $http(url: url, method: 'DELETE')
          .then ->
            $scope.enabled = true
            $scope.has_tag = false

    return

