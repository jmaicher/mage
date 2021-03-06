"use strict"

deps = [
  'ngRoute', 'ngAnimate', 'ngResource',
  'mage.utils', 'mage.hosts', 'mage.storage', 'mage.auth', 'mage.reactive', 'mage.reactive_updates', 'mage.meetings',
  'mage.services', 'mage.table.auth', 'mage.table.meeting'
]
app = angular.module('mage.table', deps)

app.config ($routeProvider, StorageProvider, AuthServiceProvider) ->
  StorageProvider.initialize("table")
  AuthServiceProvider.setAuthPath('/auth')

  $routeProvider
    .when '/',
      controller: ($rootScope, $location, meeting) ->
        # hand model to meeting ctrl via global tmp variable
        $rootScope.meeting = meeting
        $location.path "/meetings/#{meeting.model.id}"
      template: ''
      resolve:
        meeting: (MeetingService) ->
          MeetingService.create()

  return

app.run ($rootScope) ->
  $rootScope.keyup = (evt) ->
    $rootScope.$broadcast 'keyup', evt

app.controller 'AppController', ($rootScope) ->
  $rootScope.loading = true
  load = $rootScope.load = -> $rootScope.loading = true
  ready = $rootScope.ready = -> $rootScope.loading = false

  $rootScope.$on '$routeChangeStart', -> load()
  $rootScope.$on '$routeChangeError', -> ready()
  $rootScope.$on '$routeChangeSuccess', -> ready()

