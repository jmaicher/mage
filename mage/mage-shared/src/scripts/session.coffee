"use strict"

module = angular.module('mage.session', ['ngCookies', 'mage.utils'])

module.service 'SessionService', ($cookieStore, UUID) ->
  authenticable = undefined
  uuid = UUID.generate()

  # restore from session
  authenticable = $cookieStore.get('session')

  setAuthenticable = (_authenticable) ->
    authenticable = _authenticable
    $cookieStore.put('session', authenticable)

  getAuthenticable = -> authenticable

  return {
    isAuthenticated: -> !!authenticable
    getUUID: -> uuid
    getAuthenticable: getAuthenticable
    getUser: getAuthenticable
    getDevice: getAuthenticable
    setAuthenticable: setAuthenticable
    setUser: setAuthenticable
    setDevice: setAuthenticable
  }

