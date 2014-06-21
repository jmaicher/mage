"use strict"

deps = [
  # vendor
  'ngRoute', 'ngTouch', 'mobile-angular-ui',
  # app modules
  'mage.auth', 'mage.reactive', 'mage.meetings',
  'mage.mobile.notes', 'mage.mobile.auth',
  'mage.mobile.home', 'mage.mobile.deviceAuth', 'mage.mobile.meetings'
]
app = angular.module('mage.mobile', deps)

app.config ($routeProvider, $httpProvider, AuthServiceProvider) ->
  AuthServiceProvider.setAuthPath('/auth')

  $routeProvider
    .when '/',
      redirectTo: '/home'

app.run ($rootScope) ->
  $rootScope.loading = true
  load = $rootScope.load = -> $rootScope.loading = true
  ready = $rootScope.ready = -> $rootScope.loading = false

  $rootScope.$on '$routeChangeStart', -> load()
  $rootScope.$on '$routeChangeError', -> ready()
  $rootScope.$on '$routeChangeSuccess', ->
    ready()
    $rootScope.screenName = ''

