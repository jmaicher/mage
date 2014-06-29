"use strict"

module = angular.module('mage.mobile.notes', ['mage.hosts'])

module.config ($routeProvider) ->
  $routeProvider
    .when '/notes',
      templateUrl: "/views/notes.html"
      controller: 'notes.IndexCtrl'
    .when '/notes/new',
      templateUrl: "/views/notes/new.html"
      controller: 'notes.NewCtrl'
      resolve:
        backlog_item_id: -> undefined
    .when '/backlog_items/:backlog_item_id/notes/new',
      templateUrl: "/views/notes/new.html"
      controller: 'notes.NewCtrl'
      resolve:
        backlog_item_id: ($route) ->
          $route.current.params.backlog_item_id


module.service 'NoteResource', ($resource, Hosts) ->
  NoteResource = $resource "#{Hosts.api}/notes/:id", {
    'id': '@id'
  }, {
    query: {
      method: 'GET',
      isArray: false,
      transformResponse: (data, header) ->
        # Note: In case the server responds with 401, this handler is still called
        # and data will be empty. Can we check the status somehow?
        # Not sure..got no time for that now :-)
        if data.trim() != ""
          wrapped = angular.fromJson(data)
          angular.forEach wrapped.items, (item, idx) ->
            wrapped.items[idx] = new NoteResource(item)
          return wrapped
        else return data
    }
  }

  NoteResource.prototype.getImageUrl = ->
    "#{Hosts.desktop}#{@image_url}"
 
  NoteResource.prototype.hasImage = ->
    !!@image_url

  NoteResource
# NoteResource

module.service 'Note', ($q, $http, NoteResource, Hosts) ->

  build = ->
    new NoteResource()

  all = ->
    NoteResource.query().$promise

  return {
    build: build,
    all: all
  }


module.controller 'notes.IndexCtrl', ($scope, $rootScope, Note) ->
  $rootScope.loading = true

  success = (notes) ->
    console.log notes
    $rootScope.loading = false
    $scope.notes = notes.items

  failure = ->
    $rootScope.loading = false

  Note.all().then success, failure


module.directive 'onFileChange', ->
  restrict: "A",
  link: (scope, element, attrs) ->
    element.bind('change', (evt) ->
      onChangeFn = element.scope()[attrs.onFileChange]
      scope.$apply ->
        onChangeFn(evt)
    )
# onFileChange


module.directive 'imageSelect', ->
  restrict: 'E'
  templateUrl: 'views/notes/image-select.html'
  scope:
    notifyParent: '&onImageSelect'
  link: (scope, element, attr) ->
    input = element.find('.image-input')
    trigger = element.find('.attach-image-btn')

    scope.attachImage = ->
      input.click()
      return
    
    scope.onFileChange = (evt) ->
      file = input.get(0).files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        image_base64 = e.target.result
        scope.$apply ->
          scope.notifyParent(image: image_base64)
      reader.readAsDataURL(file)
      return

    return
# imageSelect

module.controller 'notes.NewCtrl', ($rootScope, $scope, $location, Note, backlog_item_id) ->
  is_attachment = !!backlog_item_id

  $rootScope.screenName = "new-note"
  $scope.note = Note.build()
  $scope.note.backlog_item_id = backlog_item_id if is_attachment

  $scope.onImageSelect = (image_base64) ->
    $scope.note.image_base64 = image_base64

  $scope.removeImage = ->
    delete $scope.note.image_base64
 
  success = (note) ->
    console.log note.getImageUrl()
    $scope.loading = false
    if is_attachment
      redirect_path = "/backlog_items/#{backlog_item_id}"
    else
      redirct_path = "/notes"
    $location.path redirect_path

  failure = (resp) ->
    $scope.loading = false
    $scope.errors = resp.data

  $scope.submit = (note) ->
    text = note.text.trim()

    first_break = text.indexOf('\n')
    if(first_break > 0)
      note.title = text.substr(0, first_break).trim()
      note.description = text.substr(first_break + 1).trim()
    else
      note.title = text

    $scope.errors = {}
    $scope.noteForm.$setPristine(true)
    $scope.loading = true

    note.$save().then success, failure

