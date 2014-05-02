"use strict"

deps = [
  # vendor
  'ngRoute', 'mobile-angular-ui', 'mobile-angular-ui.touch', 'mobile-angular-ui.scrollable'
  # app modules
  'mageMobile.ideas'
]
app = angular.module('mageMobile', deps)

app.config ($routeProvider) ->
  $routeProvider
    .when '/', templateUrl: "/views/home.html"

