"use strict"

deps = [
  # vendor
  'ngRoute', 'ngTouch', 'mobile-angular-ui',
  # app modules
  'mage.auth', 'mage.reactive', 'mage.meetings',
  'mage.mobile.product_backlog', 'mage.mobile.backlog_item', 'mage.mobile.notes', 'mage.mobile.auth',
  'mage.mobile.home', 'mage.mobile.deviceAuth', 'mage.mobile.meetings'
]
app = angular.module('mage.mobile', deps)

app.config ($routeProvider, $httpProvider, AuthServiceProvider) ->
  AuthServiceProvider.setAuthPath('/auth')

  $routeProvider
    .when '/',
      redirectTo: '/home'

app.run ($rootScope) ->
  #$rootScope.iconName = 'app-icon'
  #$rootScope.pageTitle = 'mageMobile'
  $rootScope.$watch 'screenName', (newScreenName) ->
    if newScreenName == 'new-note'
      $rootScope.iconName = 'note-icon'
      $rootScope.pageTitle = 'Quicknote'
    else
      $rootScope.iconName = 'app-icon'
      $rootScope.pageTitle = 'mageMobile'

  $rootScope.loading = true
  load = $rootScope.load = -> $rootScope.loading = true
  ready = $rootScope.ready = -> $rootScope.loading = false

  $rootScope.$on '$routeChangeStart', -> load()
  $rootScope.$on '$routeChangeError', -> ready()
  $rootScope.$on '$routeChangeSuccess', ->
    ready()
    $rootScope.screenName = ''

