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

  getApiToken = ->

  getIdentity = ->
    return undefined if !authenticable
    return {
      id: getAuthenticable().id,
      type: "TODO"
    }

  return {
    isAuthenticated: -> !!authenticable
    getUUID: -> uuid
    getAuthenticable: getAuthenticable
    getUser: getAuthenticable
    getDevice: getAuthenticable
    getIdentity: getIdentity
    setAuthenticable: setAuthenticable
    setUser: setAuthenticable
    setDevice: setAuthenticable
  }

