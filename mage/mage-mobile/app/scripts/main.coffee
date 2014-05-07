"use strict"

deps = [
  # vendor
  'ngRoute', 'ngTouch', 'mobile-angular-ui'
  # app modules
  'mageMobile.ideas'
]
app = angular.module('mageMobile', deps)

app.config ($routeProvider) ->
  $routeProvider
    .when '/', templateUrl: "/views/home.html"

