"use strict"

module = angular.module('mage.auth', ['mage.session'])

module.config ($httpProvider) ->
  $httpProvider.interceptors.push('authInterceptors')

module.run ($rootScope, $location, AuthConfig, SessionService) ->
  $rootScope.$watch (-> $location.path()), (newPath, oldPath) ->
    if(!SessionService.isAuthenticated() and newPath != AuthConfig.getSignInPath())
      $location.search(redirect_to: newPath).path('/auth')


module.provider 'AuthConfig', ->
  sign_in_path = '/auth'

  @setSignInPath = (path) ->
    sign_in_path = path

  @$get = -> {
    getSignInPath: -> sign_in_path
  }

  return

module.provider 'authInterceptors', ->

  @$get = ['$location', '$q', 'AuthConfig', 'SessionService', ($location, $q, AuthConfig, SessionService) -> {
    request: (config) ->
      if SessionService.isAuthenticated()
        config.headers['API-TOKEN'] = SessionService.getAuthenticable().api_token

      config

    responseError: (rejection) ->
      if rejection.status is 401
        redirect_to = $location.path()
        $location.search(redirect_to: redirect_to).path(AuthConfig.getSignInPath())

      return $q.reject(rejection)
  }]

  return

