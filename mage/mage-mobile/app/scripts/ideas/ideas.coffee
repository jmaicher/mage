"use strict"

ideas = angular.module('mageMobile.ideas', ['mage.hosts'])

ideas.config ($routeProvider) ->
  $routeProvider
    .when '/ideas',
      templateUrl: "/views/ideas/index.html"
      controller: 'ideas.IndexCtrl'
    .when '/ideas/new',
      templateUrl: "/views/ideas/new.html"
      controller: 'ideas.NewCtrl'

