"use strict"

deps = [
  # vendor
  'ngRoute', 'ngTouch', 'mobile-angular-ui',
  # app modules
  'mage.auth',
  'mageMobile.ideas', 'mage.mobile.auth',
  'mage.mobile.deviceAuth', 'mage.mobile.grooming'
]
app = angular.module('mageMobile', deps)

app.config ($routeProvider, $httpProvider, AuthConfigProvider) ->
  $routeProvider
    .when '/', templateUrl: "/views/home.html"
  
  AuthConfigProvider.setSignInPath('/auth')

