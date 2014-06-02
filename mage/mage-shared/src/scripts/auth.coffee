"use strict"

module = angular.module('mage.auth', ['mage.session'])

module.config ($httpProvider) ->
  $httpProvider.interceptors.push('authInterceptors')

module.run ($rootScope, $location, AuthService, SessionService) ->
  # Redirect on route change when not authenticated
  $rootScope.$watch (-> $location.path()), (new_path) ->
    if !SessionService.isAuthenticated() && !AuthService.isAuthPath(new_path)
      AuthService.redirectToAuth(new_path)

  # Redirect on init if not authenticated
  current_path = $location.path()
  if !SessionService.isAuthenticated() && !AuthService.isAuthPath(current_path)
    AuthService.redirectToAuth()


module.provider 'AuthService', ->
  auth_path = '/auth'

  @setAuthPath = (path) ->
    auth_path = path

  @$get = ($location, $injector) ->
    isAuthPath = (path) ->
      return auth_path == path

    getAuthPath = ->
      auth_path

    redirectToAuth = (redirect_path='') ->
      if(redirect_path != '')
        $location.search(redirect_to: redirect_path)
      $location.path(auth_path)

    redirectBack = ->
      # Avoid circular dependency ($route <- AuthService <- authInterceptors <- $http)
      $route = $injector.get('$route')
      redirect_path = $route.current.params.redirect_to ? '/'
      # Remove search param ?redirect_to=...
      $location.url(redirect_path)

    return {
      isAuthPath: isAuthPath
      getAuthPath: getAuthPath
      redirectToAuth: redirectToAuth
      redirectBack: redirectBack
    }
  # this.$get

  return


module.provider 'authInterceptors', ->

  @$get = ['$location', '$q', 'AuthService', 'SessionService', ($location, $q, AuthService, SessionService) -> {
    request: (config) ->
      if SessionService.isAuthenticated()
        config.headers['API-TOKEN'] = SessionService.getAuthenticable().api_token

      config

    responseError: (rejection) ->
      current_path = $location.path()
      if rejection.status is 401 && !AuthService.isAuthPath(current_path)
        redirect_to = $location.path()
        AuthService.redirectToAuth(redirect_to)

      return $q.reject(rejection)
  }]

  return


module.service 'UserAuthService', ($q, $http, Hosts) ->

  auth = (credentials) ->
    dfd = $q.defer()

    on_success = (resp) ->
      user = resp.data
      dfd.resolve(user)

    on_failure = (resp) ->
      dfd.reject(resp)

    $http.post("#{Hosts.api}/sessions", credentials)
      .then on_success, on_failure

    dfd.promise

  return {
    auth: auth
  }


module.service 'DeviceAuthService', ($q, $http, Hosts) ->

  auth = (params) ->
    dfd = $q.defer()
    url = "#{Hosts.api}/devices/sessions"
    
    success = (resp) -> dfd.resolve(resp.data)
    failure = (resp) -> dfd.reject(resp.status, resp.data)

    $http.post(url, params).then(success, failure)

    dfd.promise

  requestAuthPin = (uuid) ->
    dfd = $q.defer()

    on_success = (resp) ->
      dfd.resolve(resp.data.pin)

    on_error = ->
      dfd.reject

    $http.post("#{Hosts.api}/devices/sessions/pins", {
      uuid: uuid
    }).then on_success, on_error

    dfd.promise

  return {
    auth: auth
    requestAuthPin: requestAuthPin
  }

